package service.hq.warehouse;

public interface WarehouseStockAlertService {
	void sendWarehouseAlerts(int accountId) throws Exception;
}
