package service.hq.place_order;

import java.util.List;

import dto.hq.place_order.PlaceOrderProcessingDTO;
import dto.hq.place_order.PlaceOrderProcessingDetailDTO;

public interface PlaceOrderProcessingService {
    List<PlaceOrderProcessingDTO> getPendingOrders();

    PlaceOrderProcessingDTO getOrderDetail(String poNo);

    boolean approveOrder(String poNo, List<PlaceOrderProcessingDetailDTO> details);

    boolean rejectOrder(String poNo, String rejectReason);
}
