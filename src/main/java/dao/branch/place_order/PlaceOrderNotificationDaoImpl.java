package dao.branch.place_order;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.NotificationDTO;
import dto.NotificationReceiverDTO;

public class PlaceOrderNotificationDaoImpl implements PlaceOrderNotificationDao {
	
    private static final String MAPPER_NAMESPACE = "mapper.branch.placeOrderMapper.";

	@Override
    public int insertNotification(SqlSession sqlSession, NotificationDTO dto) {
        return sqlSession.insert(MAPPER_NAMESPACE + "insertNotification", dto);
    }

	@Override
	public List<Integer> selectAccountIdsByBranchCode(SqlSession sqlSession, Integer branchCode) {
        return sqlSession.selectList(MAPPER_NAMESPACE + "selectAccountIdsByBranchCode", branchCode);
	}

	@Override
	public int insertNotifiReceiver(SqlSession sqlSession, NotificationReceiverDTO receiverDTO) {
        return sqlSession.insert(MAPPER_NAMESPACE + "insertNotifiReceiver", receiverDTO);

	}
}
