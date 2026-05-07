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
		// 1. 유통기한 만료
		List<WarehouseStockDTO> expiredList = warehouseAlertDao.selectExpiredStock();
		for (WarehouseStockDTO stock : expiredList) {
			sendIfNotExists(accountId, "[본사] 물류창고 재고 유통기한 만료", stock.getMaterialName() + "의 유통기한이 만료되었습니다.");
		}

		// 2. 유통기한 긴급 (1일 이내)
		List<WarehouseStockDTO> urgentList = warehouseAlertDao.selectUrgentStock();
		for (WarehouseStockDTO stock : urgentList) {
			sendIfNotExists(accountId, "[본사] 물류창고 재고 유통기한 긴급", stock.getMaterialName() + "의 유통기한이 1일 이내로 남았습니다.");
		}

		// 3. 유통기한 경고 (3일 이내)
		List<WarehouseStockDTO> warningList = warehouseAlertDao.selectWarningStock();
		for (WarehouseStockDTO stock : warningList) {
			sendIfNotExists(accountId, "[본사] 물류창고 재고 유통기한 경고", stock.getMaterialName() + "의 유통기한이 3일 이내로 남았습니다.");
		}
	}

	private void sendIfNotExists(int accountId, String title, String message) throws Exception {
		NotificationDTO notif = new NotificationDTO();
		notif.setAccountId(accountId);
		notif.setTitle(title);
		notif.setMessage(message);

		if (!warehouseAlertDao.existsTodayNotification(notif)) {
			warehouseAlertDao.insertNotification(notif);
			warehouseAlertDao.insertNotificationReceiver(notif);
		}
	}

}
