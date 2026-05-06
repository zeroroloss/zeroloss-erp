package dao.branch.place_order;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.NotificationDTO;
import dto.NotificationReceiverDTO;

public interface PlaceOrderNotificationDao {

	int insertNotification(SqlSession sqlSession, NotificationDTO dto);
	
	List<Integer> selectAccountIdsByBranchCode(SqlSession sqlSession, Integer branchCode);

	int insertNotifiReceiver(SqlSession sqlSession, NotificationReceiverDTO receiverDTO);
}
