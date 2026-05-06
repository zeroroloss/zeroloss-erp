package dao.branch.stock;

import dto.NotificationDTO;

public interface BranchNotificationDao {
	void insertNotification(NotificationDTO notification) throws Exception;

    void insertNotificationReceiver(NotificationDTO notification) throws Exception;

    boolean existsTodayNotification(NotificationDTO notification) throws Exception;
}
