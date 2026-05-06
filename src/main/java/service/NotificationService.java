package service;

import java.util.List;

import dto.NotificationDTO;

public interface NotificationService {
	// 알림 대시보드
	Integer selectNotifCnt(Integer accountId) throws Exception;
	Integer selectIsReadCnt(Integer accountId) throws Exception;
	Integer selectTodayCnt(NotificationDTO notification) throws Exception;
	
	// 알림 조회
	List<NotificationDTO> searchNotificationList(Integer accountId) throws Exception;
	
	// 읽음 처리
	void modifyIsRead(NotificationDTO notification) throws Exception;
}
