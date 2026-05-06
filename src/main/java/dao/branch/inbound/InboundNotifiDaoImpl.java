package dao.branch.inbound;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.NotificationDTO;
import dto.NotificationReceiverDTO;
import dto.hq.place_order.PlaceOrderProcessingDTO;

public class InboundNotifiDaoImpl implements InboundNotifiDao {

	private static final String MAPPER_NAMESPACE = "mapper.inbound.notifi.";

	@Override
	public int insertNotification(SqlSession sqlSession, NotificationDTO dto) {
		return sqlSession.insert(MAPPER_NAMESPACE + "insertNotification", dto);
	}

	@Override
	public int insertReceiver(SqlSession sqlSession, NotificationReceiverDTO dto) {
		return sqlSession.insert(MAPPER_NAMESPACE + "insertReceiver", dto);
	}

	@Override
	public List<Integer> findHqAccountIds(SqlSession sqlSession) {
		return sqlSession.selectList(MAPPER_NAMESPACE + "findHqAccountIds");
	}

	@Override
	public PlaceOrderProcessingDTO selectOrderHeaderByPoNo(SqlSession sqlSession, String poNo) {
		return sqlSession.selectOne(MAPPER_NAMESPACE + "findPlaceOrderHeaderByPoNo", poNo);
	}
}