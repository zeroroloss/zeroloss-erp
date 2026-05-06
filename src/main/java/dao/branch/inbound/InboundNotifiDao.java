package dao.branch.inbound;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.NotificationDTO;
import dto.NotificationReceiverDTO;
import dto.hq.place_order.PlaceOrderProcessingDTO;

public interface InboundNotifiDao {

	int insertNotification(SqlSession sqlSession, NotificationDTO dto);

	int insertReceiver(SqlSession sqlSession, NotificationReceiverDTO dto);

	List<Integer> findHqAccountIds(SqlSession sqlSession);

	PlaceOrderProcessingDTO selectOrderHeaderByPoNo(SqlSession sqlSession, String poNo);
}