package dao.branch.stock;

import java.util.List;

import dto.NotificationDTO;

public interface BranchNotificationDao {
	void insertNotification(NotificationDTO notification) throws Exception;

    void insertNotificationReceiver(NotificationDTO notification) throws Exception;

    boolean existsTodayNotification(NotificationDTO notification) throws Exception;

	List<Integer> selectBranchAccountIds(int branchCode) throws Exception;
}
