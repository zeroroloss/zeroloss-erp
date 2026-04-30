package dao.branch.place_order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.branch.place_order.PlaceOrderDetailDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.branch.place_order.PlaceOrderDTO;

public interface PlaceOrderDAO {

	//발주 이력 목록을 조회
    List<PlaceOrderHistoryDTO> selectPlaceOrderHistory(SqlSession sqlSession, Map<String, Object> queryParams);

    // 발주서 번호 기준의 단건 이력을 조회
    PlaceOrderHistoryDTO selectPlaceOrderDetail(SqlSession sqlSession, String poNo);

    // 발주서 번호 기준의 품목 상세 목록을 조회
    List<PlaceOrderDetailDTO> selectPlaceOrderDetails(SqlSession sqlSession, String poNo);

    // 발주서 생성
    int insertPlaceOrder(SqlSession sqlSession, PlaceOrderDTO placeOrderDTO);
    
    // 발주서 번호 조회
    String findPlaceOrderNo(SqlSession sqlSession, int placeOrderId);

    // 발주서의 품목 상세 생성
    int insertPlaceOrderDetails(SqlSession sqlSession, Integer poId, List<PlaceOrderDetailDTO> detailDTOs);

    // 발주서 상태, 반려 사유 갱신
    int updatePlaceOrderStatus(SqlSession sqlSession, Map<String, Object> updateParams);
    
    // 발주서 번호 (pONo) 변경
	int updatePlaceOrderNo(SqlSession sqlSession, Integer poId, String poNo);

}