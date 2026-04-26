package dao.branch.place_order;

import java.util.List;
import java.util.Map;

import dto.branch.place_order.PlaceOrderDetailDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.branch.place_order.PlaceOrderRequestDTO;
import dto.branch.place_order.PlaceOrderRequestDetailDTO;

public interface PlaceOrderDAO {

    List<PlaceOrderHistoryDTO> selectPlaceOrderHistory(Map<String, Object> params);
    PlaceOrderHistoryDTO selectPlaceOrderDetail(String poNo);
    List<PlaceOrderDetailDTO> selectPlaceOrderDetails(String poNo);
    int insertPlaceOrder(PlaceOrderRequestDTO requestDTO);
    int insertPlaceOrderDetails(Integer poId, List<PlaceOrderRequestDetailDTO> details);
    int updatePlaceOrderStatus(Map<String, Object> params);
}