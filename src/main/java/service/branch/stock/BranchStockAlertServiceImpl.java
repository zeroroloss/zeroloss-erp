package service.branch.stock;

import java.util.List;

import dao.NotificationDao;
import dao.NotificationDaoImpl;
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
		// 1. 유통기한 만료
		List<BranchStockDTO> expiredList = stockAlertDao.selectExpiredStock(branchCode);
		for (BranchStockDTO stock : expiredList) {
			sendIfNotExists(accountId, branchCode, "[지점] 지점 재고 유통기한 만료", stock.getMaterialName() + "의 유통기한이 만료되었습니다.");
		}

		// 2. 유통기한 긴급 (1일 이내)
		List<BranchStockDTO> urgentList = stockAlertDao.selectUrgentStock(branchCode);
		for (BranchStockDTO stock : urgentList) {
			sendIfNotExists(accountId, branchCode, "[지점] 지점 재고 유통기한 긴급",
					stock.getMaterialName() + "의 유통기한이 1일 이내로 남았습니다.");
		}

		// 3. 유통기한 경고 (3일 이내)
		List<BranchStockDTO> warningList = stockAlertDao.selectWarningStock(branchCode);
		for (BranchStockDTO stock : warningList) {
			sendIfNotExists(accountId, branchCode, "[지점] 지점 재고 유통기한 경고",
					stock.getMaterialName() + "의 유통기한이 3일 이내로 남았습니다.");
		}

		// 4. 재고 완전 소진
		List<BranchStockDTO> emptyList = stockAlertDao.selectEmptyStock(branchCode);
		for (BranchStockDTO stock : emptyList) {
		    sendIfNotExists(accountId, branchCode,
		        "[지점] 재고 소진 알림",
		        stock.getMaterialName() + "의 재고가 완전히 소진되었습니다."
		    );
		}

		// 5. 안전재고 미달 (0 제외)
		List<BranchStockDTO> lackList = stockAlertDao.selectLackStock(branchCode);
		for (BranchStockDTO stock : lackList) {
		    sendIfNotExists(accountId, branchCode,
		        "[지점] 재고 소진 알림",
		        stock.getMaterialName() + "의 재고가 안전재고 이하로 떨어졌습니다."
		    );
		}
	}

	private void sendIfNotExists(int accountId, int branchCode, String title, String message) throws Exception {
		NotificationDTO notif = new NotificationDTO();
		notif.setAccountId(accountId);
		notif.setTargetId(branchCode);
		notif.setTitle(title);
		notif.setMessage(message);

		if (!notificationDao.existsTodayNotification(notif)) {
			notificationDao.insertNotification(notif);
			notificationDao.insertNotificationReceiver(notif);
		}
	}
}
