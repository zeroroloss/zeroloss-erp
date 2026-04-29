package service.branch.place_order;

import java.util.List;

import dto.branch.place_order.PlaceOrderDraftDTO;
import dto.branch.place_order.PlaceOrderDraftDetailDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.branch.place_order.PlaceOrderRequestDTO;

public interface PlaceOrderService {

	// 발주 내역
    List<PlaceOrderHistoryDTO> getPlaceOrderHistoryList(int branchCode, String startDate, String endDate, String status);
    PlaceOrderHistoryDTO getPlaceOrderDetail(String poNo);
    boolean createPlaceOrder(PlaceOrderRequestDTO requestDTO);
    boolean updatePlaceOrderStatus(String poNo, String status, String rejectReason);
    
    // 발주서 생성
	PlaceOrderDraftDTO findOrCreateInProgressDraft(int branchCode);
}