package dao.hq.delivery;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.hq.place_order.PlaceOrderProcessingDTO;

public interface DispatchNotifiDao {
    int insertNotification(SqlSession sqlSession, dto.NotificationDTO dto);

    List<Integer> findAccountIdsByPoNo(SqlSession sqlSession, String poNo);

    int insertNotifiReceiver(SqlSession sqlSession, dto.NotificationReceiverDTO dto);

	PlaceOrderProcessingDTO findPlaceOrderHeaderByPoNo(SqlSession sqlSession, String poNo);

}
