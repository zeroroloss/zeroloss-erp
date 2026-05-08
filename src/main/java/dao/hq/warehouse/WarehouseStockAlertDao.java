package dao.hq.warehouse;

import java.util.List;

import dto.NotificationDTO;
import dto.WarehouseStockDTO;

public interface WarehouseStockAlertDao {
	
	List<WarehouseStockDTO> selectExpiredStock() throws Exception;

    List<WarehouseStockDTO> selectUrgentStock() throws Exception;

    List<WarehouseStockDTO> selectWarningStock() throws Exception;

    int insertNotification(NotificationDTO notification) throws Exception;

    void insertNotificationReceiver(NotificationDTO notification) throws Exception;

    boolean existsTodayNotification(NotificationDTO notification) throws Exception;

	List<Integer> selectHqAccountIds(int accountId) throws Exception;
}
