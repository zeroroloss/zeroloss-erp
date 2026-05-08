package service.hq.warehouse;

import java.util.List;

import dao.hq.warehouse.WarehouseStockAlertDao;
import dao.hq.warehouse.WarehouseStockAlertDaoImpl;
import dto.NotificationDTO;
import dto.WarehouseStockDTO;

public class WarehouseStockAlertServiceImpl implements WarehouseStockAlertService {

	private WarehouseStockAlertDao warehouseAlertDao;

	public WarehouseStockAlertServiceImpl() {
		warehouseAlertDao = new WarehouseStockAlertDaoImpl();
	}

	@Override
	public void sendWarehouseAlerts(int accountId) throws Exception {

	    // 동일 소속(본사) 계정들 조회
	    List<Integer> accountIds = warehouseAlertDao.selectHqAccountIds(accountId);

	    // 1) 유통기한 만료
	    List<WarehouseStockDTO> expiredList = warehouseAlertDao.selectExpiredStock();
	    for (WarehouseStockDTO stock : expiredList) {
	        sendNotificationIfNotExists(accountIds, stock.getId(), 
	            "[본사] 물류창고 재고 유통기한 만료", stock.getMaterialName() + "(재고번호: " + stock.getStockNo() + ")의 유통기한이 만료되었습니다."
	        );
	    }

	    // 2) 유통기한 긴급 (1일 이내)
	    List<WarehouseStockDTO> urgentList = warehouseAlertDao.selectUrgentStock();
	    for (WarehouseStockDTO stock : urgentList) {
	        sendNotificationIfNotExists(accountIds, stock.getId(),
	            "[본사] 물류창고 재고 유통기한 긴급", stock.getMaterialName() + "(재고번호: " + stock.getStockNo() + ")의 유통기한이 1일 이내로 남았습니다."
	        );
	    }

	    // 3) 유통기한 경고 (3일 이내)
	    List<WarehouseStockDTO> warningList = warehouseAlertDao.selectWarningStock();
	    for (WarehouseStockDTO stock : warningList) {
	        sendNotificationIfNotExists(accountIds, stock.getId(),
	            "[본사] 물류창고 재고 유통기한 경고", stock.getMaterialName() + "(재고번호: " + stock.getStockNo() + ")의 유통기한이 3일 이내로 남았습니다."
	        );
	    }
	    
	}

	private void sendNotificationIfNotExists(List<Integer> accountIds, int targetId, String title, String message) throws Exception {

	    NotificationDTO notif = new NotificationDTO();
	    notif.setCategory("INVENTORY");
	    notif.setTitle(title);
	    notif.setMessage(message);
	    notif.setTargetType("HQ_INVENTORY");
	    notif.setTargetId(targetId);
	    
	    // 중복 체크
	    if (warehouseAlertDao.existsTodayNotification(notif)) {
	        return;
	    }

        // 1) notification 1건 생성
	    warehouseAlertDao.insertNotification(notif);
	    Integer notificationId = notif.getNotificationId(); // generatedKey

        // 2) receiver 여러 개 insert
	    for (Integer accId : accountIds) {
	        NotificationDTO receiver = new NotificationDTO();
	        receiver.setNotificationId(notificationId);
	        receiver.setAccountId(accId);

	        warehouseAlertDao.insertNotificationReceiver(receiver);
	    }
	}
}
