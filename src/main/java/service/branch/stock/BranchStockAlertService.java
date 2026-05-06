package service.branch.stock;

public interface BranchStockAlertService {
	void sendStockAlerts(int branchCode, int accountId) throws Exception;
}
