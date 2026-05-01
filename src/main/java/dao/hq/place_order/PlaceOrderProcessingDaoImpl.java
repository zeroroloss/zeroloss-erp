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

    @Override
    public int deductWarehouseStock(SqlSession sqlSession, Map<String, Object> param) throws Exception {
        return sqlSession.update(NAMESPACE + "deductWarehouseStock", param);
    }
}
