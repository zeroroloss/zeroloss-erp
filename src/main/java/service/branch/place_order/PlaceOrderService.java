package service.branch.place_order;

import java.util.List;
import java.util.Map;

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
	
	// 발주서 생성 - API 응답
	List<Map<String, Object>> getSelectableItems(int branchCode, String category, String item, String search);
	
	// 발주 임시 상세 추가/삭제
	boolean updatePlaceOrderDraftDetail(int branchCode, String action, PlaceOrderDraftDetailDTO detailDTO);
	
}