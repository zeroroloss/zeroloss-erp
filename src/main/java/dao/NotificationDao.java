package dao;

import java.util.List;

import dto.NotificationDTO;

public interface NotificationDao {
	// 알림 대시보드
	Integer selectNotifCnt(Integer accountId) throws Exception;
	Integer selectIsReadCnt(Integer accountId) throws Exception;
	Integer selectTodayCnt(NotificationDTO notification) throws Exception;
	
	// 알림 조회
	List<NotificationDTO> selectNotificationList(Integer accountId) throws Exception;
	
	// 읽음 처리
	void updateIsRead(NotificationDTO notification) throws Exception;
}
