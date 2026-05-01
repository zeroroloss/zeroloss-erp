package dao.hq.place_order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.hq.place_order.PlaceOrderProcessingDTO;
import dto.hq.place_order.PlaceOrderProcessingDetailDTO;

public interface PlaceOrderProcessingDao {
    List<PlaceOrderProcessingDTO> selectPendingOrders(SqlSession sqlSession) throws Exception;

    PlaceOrderProcessingDTO selectOrderHeaderByPoNo(SqlSession sqlSession, String poNo) throws Exception;

    List<PlaceOrderProcessingDetailDTO> selectOrderDetailsByPoNo(SqlSession sqlSession, String poNo) throws Exception;

    int updateOrderStatusApprove(SqlSession sqlSession, String poNo) throws Exception;

    int updateOrderStatusReject(SqlSession sqlSession, Map<String, Object> param) throws Exception;

    int updateApprovedQtyByDetailId(SqlSession sqlSession, Map<String, Object> param) throws Exception;

    int deductWarehouseStock(SqlSession sqlSession, Map<String, Object> param) throws Exception;
}
