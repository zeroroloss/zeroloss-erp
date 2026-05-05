package dao.hq.place_order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.hq.place_order.PlaceOrderProcessingDTO;
import dto.hq.place_order.PlaceOrderProcessingDetailDTO;

public class PlaceOrderProcessingDaoImpl implements PlaceOrderProcessingDao {

    private static final String NAMESPACE = "mapper.hq.place_order.PlaceOrderProcessingMapper.";

    @Override
    public List<PlaceOrderProcessingDTO> selectPendingOrders(SqlSession sqlSession) throws Exception {
        return sqlSession.selectList(NAMESPACE + "selectPendingOrders");
    }

    @Override
    public PlaceOrderProcessingDTO selectOrderHeaderByPoNo(SqlSession sqlSession, String poNo) throws Exception {
        return sqlSession.selectOne(NAMESPACE + "selectOrderHeaderByPoNo", poNo);
    }

    @Override
    public List<PlaceOrderProcessingDetailDTO> selectOrderDetailsByPoNo(SqlSession sqlSession, String poNo) throws Exception {
        return sqlSession.selectList(NAMESPACE + "selectOrderDetailsByPoNo", poNo);
    }

    @Override
    public int updateOrderStatusApprove(SqlSession sqlSession, String poNo) throws Exception {
        return sqlSession.update(NAMESPACE + "updateOrderStatusApprove", poNo);
    }

    @Override
    public int updateOrderStatusReject(SqlSession sqlSession, Map<String, Object> param) throws Exception {
        return sqlSession.update(NAMESPACE + "updateOrderStatusReject", param);
    }

    @Override
    public int updateApprovedQtyByDetailId(SqlSession sqlSession, Map<String, Object> param) throws Exception {
        return sqlSession.update(NAMESPACE + "updateApprovedQtyByDetailId", param);
    }
    
    // ====================================
    // 출고 처리 - 재고 감소
    @Override
    public List<Map<String, Object>> selectStockLotsByMaterialCode(SqlSession sqlSession, String materialCode) {
        return sqlSession.selectList(NAMESPACE + "selectStockLotsByMaterialCode", materialCode);
    }

    @Override
    public int deductWarehouseStockByStockNo(SqlSession sqlSession, Map<String, Object> param) {
        return sqlSession.update(NAMESPACE + "deductWarehouseStockByStockNo", param);
    }

    @Override
    public int updateStockStatusIfEmpty(SqlSession sqlSession, String stockNo) {
        return sqlSession.update(NAMESPACE + "updateStockStatusIfEmpty", stockNo);
    }

    // ====================================
    // 출고 내역
    @Override
    public int insertOutbound(SqlSession sqlSession, Map<String, Object> param) {
        return sqlSession.insert(NAMESPACE + "insertOutbound", param);
    }

    @Override
    public int insertOutboundDetail(SqlSession sqlSession, Map<String, Object> param) {
        return sqlSession.insert(NAMESPACE + "insertOutboundDetail", param);
    }

	@Override
	public Map<String, Object> selectStockByStockNo(SqlSession sqlSession, String stockNo) {        
		return sqlSession.selectOne(NAMESPACE + "selectStockByStockNo", stockNo);
	}

	@Override
	public int insertStockHistory(SqlSession sqlSession, Map<String, Object> param) {
        return sqlSession.insert(NAMESPACE + "insertStockHistory", param);
	}



}
