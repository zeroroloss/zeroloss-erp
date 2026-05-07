package dao.branch.place_order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.branch.place_order.PlaceOrderDetailDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.NotificationDTO;
import dto.NotificationReceiverDTO;
import dto.branch.place_order.PlaceOrderDTO;

public class PlaceOrderDAOImpl implements PlaceOrderDAO {

    private static final String MAPPER_NAMESPACE = "mapper.branch.placeOrderMapper.";

    @Override
    public List<PlaceOrderHistoryDTO> selectPlaceOrderHistory(SqlSession sqlSession, Map<String, Object> params) {
        return sqlSession.selectList(MAPPER_NAMESPACE + "selectPlaceOrderHistory", params);
    }

    @Override
    public PlaceOrderHistoryDTO selectPlaceOrderDetail(SqlSession sqlSession, String poNo) {
        return sqlSession.selectOne(MAPPER_NAMESPACE + "selectPlaceOrderDetail", poNo);
    }

    @Override
    public List<PlaceOrderDetailDTO> selectPlaceOrderDetails(SqlSession sqlSession, String poNo) {
        return sqlSession.selectList(MAPPER_NAMESPACE + "selectPlaceOrderDetails", poNo);
    }

    @Override
    public int insertPlaceOrder(SqlSession sqlSession, PlaceOrderDTO placeOrderDTO) {
        int result = sqlSession.insert(MAPPER_NAMESPACE + "insertPlaceOrder", placeOrderDTO);
        return result;
    }	
    
	@Override
	public Integer insertPlaceOrderDetails(SqlSession sqlSession, Integer poId,
											List<PlaceOrderDetailDTO> draftDetailDTOs) {
        Map<String, Object> params = new HashMap<>();
        params.put("poId", poId);
        params.put("details", draftDetailDTOs);
        return sqlSession.insert(MAPPER_NAMESPACE + "insertPlaceOrderDetails", params);
	}
	
	@Override
	public PlaceOrderDTO findPlaceOrder(SqlSession sqlSession, String poNo) {
		return sqlSession.selectOne(MAPPER_NAMESPACE + "findPlaceOrder", poNo);
	}
    
	@Override
	public String findPlaceOrderNo(SqlSession sqlSession, int placeOrderId) {
		return sqlSession.selectOne(MAPPER_NAMESPACE + "findPlaceOrderNo", placeOrderId);
	}
	
    @Override
    public int updatePlaceOrderStatus(SqlSession sqlSession, String poNo, String status) {
        Map<String, Object> params = new HashMap<>();
    	params.put("poNo", poNo);
    	params.put("status", status);
        int result = sqlSession.update(MAPPER_NAMESPACE + "updatePlaceOrderStatus", params);
        return result;
    }
	@Override
	public int updatePlaceOrderStatusCancel(SqlSession sqlSession, String poNo, String cancelReason) {
        Map<String, Object> params = new HashMap<>();
    	params.put("poNo", poNo);
    	params.put("status", "CANCELED");
    	params.put("reject_reason", cancelReason);
        int result = sqlSession.update(MAPPER_NAMESPACE + "updatePlaceOrderStatusCancel", params);
        return result;
	}

	@Override
	public int updatePlaceOrderNo(SqlSession sqlSession, Integer poId, String poNo) {
		Map<String, Object> params = new HashMap<>();
		params.put("poId", poId);
		params.put("poNo", poNo);
		return sqlSession.update(MAPPER_NAMESPACE + "updatePlaceOrderNo", params);
	}

	@Override
	public String findBranchName(SqlSession sqlSession, Integer branchCode) {
	    return sqlSession.selectOne(MAPPER_NAMESPACE + "findBranchName", branchCode);
	}
	
	//====================
	// 알림처리
	@Override
	public int insertNotification(SqlSession sqlSession, NotificationDTO dto) {
	    return sqlSession.insert(MAPPER_NAMESPACE + "insertNotification", dto);
	}

	@Override
	public List<Integer> selectHqAccountIds(SqlSession sqlSession) {
	    return sqlSession.selectList(MAPPER_NAMESPACE + "selectHqAccountIds");
	}

	@Override
	public void insertNotifiReceiver(SqlSession sqlSession, NotificationReceiverDTO receiver) {
	    sqlSession.insert(MAPPER_NAMESPACE + "insertNotifiReceiver", receiver);
	}
}