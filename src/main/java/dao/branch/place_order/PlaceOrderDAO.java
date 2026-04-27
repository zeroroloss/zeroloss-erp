package dao.branch.place_order;

import java.util.List;
import java.util.Map;

import dto.branch.place_order.PlaceOrderDetailDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.branch.place_order.PlaceOrderRequestDTO;
import dto.branch.place_order.PlaceOrderRequestDetailDTO;

public interface PlaceOrderDAO {

	//발주 이력 목록을 조회
    List<PlaceOrderHistoryDTO> selectPlaceOrderHistory(Map<String, Object> queryParams);

    // 발주서 번호 기준의 단건 이력을 조회
    PlaceOrderHistoryDTO selectPlaceOrderDetail(String poNo);

    // 발주서 번호 기준의 품목 상세 목록을 조회
    List<PlaceOrderDetailDTO> selectPlaceOrderDetails(String poNo);

    // 발주서를 생성
    int insertPlaceOrder(PlaceOrderRequestDTO requestDTO);

    // 발주서의 품목 상세를 생성
    int insertPlaceOrderDetails(Integer poId, List<PlaceOrderRequestDetailDTO> details);

    // 발주서 상태와 반려 사유를 갱신
    int updatePlaceOrderStatus(Map<String, Object> updateParams);
}