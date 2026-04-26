package service.branch.place_order;

import java.util.List;

import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.branch.place_order.PlaceOrderRequestDTO;

public interface PlaceOrderService {

    List<PlaceOrderHistoryDTO> getPlaceOrderHistory(int branchCode, String startDate, String endDate, String status);
    PlaceOrderHistoryDTO getPlaceOrderDetail(String poNo);
    boolean createPlaceOrder(PlaceOrderRequestDTO requestDTO);
    boolean updatePlaceOrderStatus(String poNo, String status, String rejectReason);
}