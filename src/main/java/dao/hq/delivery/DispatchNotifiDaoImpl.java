package dao.hq.delivery;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.NotificationDTO;
import dto.NotificationReceiverDTO;
import dto.hq.place_order.PlaceOrderProcessingDTO;

public class DispatchNotifiDaoImpl implements DispatchNotifiDao {
    private static final String MAPPER_NAMESPACE = "mapper.hq.delivery.";

    @Override
    public int insertNotification(SqlSession sqlSession, NotificationDTO dto) {
        return sqlSession.insert(MAPPER_NAMESPACE + "insertNotification", dto);
    }

    @Override
    public List<Integer> findAccountIdsByPoNo(SqlSession sqlSession, String poNo) {
        return sqlSession.selectList(MAPPER_NAMESPACE + "selectAccountIdsByPoNo", poNo);
    }

    @Override
    public int insertNotifiReceiver(SqlSession sqlSession, NotificationReceiverDTO dto) {
        return sqlSession.insert(MAPPER_NAMESPACE + "insertNotifiReceiver", dto);
    }

	@Override
	public PlaceOrderProcessingDTO findPlaceOrderHeaderByPoNo(SqlSession sqlSession, String poNo) {
        return sqlSession.selectOne(MAPPER_NAMESPACE + "findPlaceOrderHeaderByPoNo", poNo);

	}

}
