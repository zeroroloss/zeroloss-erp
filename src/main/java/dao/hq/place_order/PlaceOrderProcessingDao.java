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

    // 출고 처리
    List<Map<String, Object>> selectStockLotsByMaterialCode(SqlSession sqlSession, String materialCode);
	int deductWarehouseStockByStockNo(SqlSession sqlSession, Map<String, Object> param);
	int updateStockStatusIfEmpty(SqlSession sqlSession, String stockNo);
	
    // 출고 내역
    int insertOutbound(SqlSession sqlSession, Map<String, Object> param);
    int insertOutboundDetail(SqlSession sqlSession, Map<String, Object> param);
}
