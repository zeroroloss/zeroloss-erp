package service.branch.stock;

import java.util.List;

import dao.branch.stock.BranchNotificationDao;
import dao.branch.stock.BranchNotificationDaoImpl;
import dao.branch.stock.BranchStockAlertDao;
import dao.branch.stock.BranchStockAlertDaoImpl;
import dto.BranchStockDTO;
import dto.NotificationDTO;

public class BranchStockAlertServiceImpl implements BranchStockAlertService {

	private BranchStockAlertDao stockAlertDao;
	private BranchNotificationDao notificationDao;

	public BranchStockAlertServiceImpl() {
		stockAlertDao = new BranchStockAlertDaoImpl();
		notificationDao = new BranchNotificationDaoImpl();
	}

	@Override
	public void sendStockAlerts(int branchCode, int accountId) throws Exception {
		System.out.println("BranchStockAlertServiceImpl - 지점 재고 알림 전송");
		// 지점 전체 계정 조회
		List<Integer> accountIds = notificationDao.selectBranchAccountIds(branchCode);

		// ===== 유통기한 ================

		// 1. 유통기한 만료
		List<BranchStockDTO> expiredList = stockAlertDao.selectExpiredStock(branchCode);
		for (BranchStockDTO stock : expiredList) {
			sendIfNotExists(accountIds, stock.getBranchStockId(), "[재고 유통기한 만료]",
					stock.getMaterialName() + " (재고번호: " + stock.getBranchStockCode() + ")의 유통기한이 만료되었습니다." + " [만료일: "
							+ stock.getExpireDate() + "]");
		}

		// 2. 유통기한 긴급
		List<BranchStockDTO> urgentList = stockAlertDao.selectUrgentStock(branchCode);
		for (BranchStockDTO stock : urgentList) {
			sendIfNotExists(accountIds, stock.getBranchStockId(), "[재고 유통기한 긴급]",
					stock.getMaterialName() + " (재고번호: " + stock.getBranchStockCode() + ")의 유통기한이 1일 이내로 남았습니다."
							+ " [만료일: " + stock.getExpireDate() + "]");
		}

		// 3. 유통기한 경고
		List<BranchStockDTO> warningList = stockAlertDao.selectWarningStock(branchCode);
		for (BranchStockDTO stock : warningList) {
			sendIfNotExists(accountIds, stock.getBranchStockId(), "[재고 유통기한 경고]",
					stock.getMaterialName() + " (재고번호: " + stock.getBranchStockCode() + ")의 유통기한이 3일 이내로 남았습니다."
							+ " [만료일: " + stock.getExpireDate() + "]");
		}

		// ===== 재고 소진 ================

		List<BranchStockDTO> emptyList = stockAlertDao.selectEmptyStock(branchCode);
		for (BranchStockDTO stock : emptyList) {
			sendIfNotExists(accountIds, stock.getBranchStockId(), "[재고 소진 알림]",
					stock.getMaterialName() + " (재고번호: " + stock.getBranchStockCode() + ")의 재고가 완전히 소진되었습니다."
							+ " [현재 재고: " + stock.getCurrentQty() + stock.getUnit() + "]");
		}

		// ===== 안전재고 미달 ================

		List<BranchStockDTO> lackList = stockAlertDao.selectLackStock(branchCode);
		for (BranchStockDTO stock : lackList) {
			sendIfNotExists(accountIds, stock.getBranchStockId(), "[재고 부족 알림]",
					stock.getMaterialName() + " (재고번호: " + stock.getBranchStockCode() + ")의 재고가 안전재고 이하입니다."
							+ " [현재 재고: " + stock.getCurrentQty() + stock.getUnit() + " / 안전재고: "
							+ stock.getSafeStockQty() + stock.getUnit() + "]");
		}
	}

	private void sendIfNotExists(List<Integer> accountIds, int targetId, String title, String message)
			throws Exception {

		NotificationDTO notif = new NotificationDTO();

		notif.setCategory("INVENTORY");
		notif.setTargetType(resolveTargetType(title));
		notif.setTargetId(targetId);
		notif.setTitle(title);
		notif.setMessage(message);

		// 중복 체크
		if (notificationDao.existsTodayNotification(notif)) {
			return;
		}

		// insert notification
		notificationDao.insertNotification(notif);

		// insert receiver
		for (Integer accId : accountIds) {
			NotificationDTO receiver = new NotificationDTO();
			receiver.setNotificationId(notif.getNotificationId());
			receiver.setAccountId(accId);

			notificationDao.insertNotificationReceiver(receiver);
		}
	}

	private String resolveTargetType(String title) {
		if (title.contains("유통기한"))
			return "BRANCH_EXPIRY";

		if (title.contains("재고 부족") || title.contains("재고 소진"))
			return "BRANCH_SAFETY";

		return "";
	}
}
