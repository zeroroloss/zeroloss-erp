package service;

import java.util.List;

import dao.NotificationDao;
import dao.NotificationDaoImpl;
import dto.NotificationDTO;

public class NotificationServiceImpl implements NotificationService {
	private NotificationDao notifDao;
	
	public NotificationServiceImpl() {
		notifDao = new NotificationDaoImpl();
	}

	@Override
	public Integer selectNotifCnt(Integer accountId) throws Exception {
		return notifDao.selectNotifCnt(accountId);
	}

	@Override
	public Integer selectIsReadCnt(Integer accountId) throws Exception {
		return notifDao.selectIsReadCnt(accountId);
	}

	@Override
	public Integer selectTodayCnt(NotificationDTO notification) throws Exception {
		return notifDao.selectTodayCnt(notification);
	}

	@Override
	public List<NotificationDTO> searchNotificationList(Integer accountId) throws Exception {
		return notifDao.selectNotificationList(accountId);
	}

	@Override
	public void modifyIsRead(NotificationDTO notification) throws Exception {
		notifDao.updateIsRead(notification);
	}

}
