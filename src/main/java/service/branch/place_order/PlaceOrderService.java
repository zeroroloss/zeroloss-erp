package service.branch.place_order;

import java.util.List;
import java.util.Map;

import dto.MaterialDTO;
import dto.MaterialGroupDTO;
import dto.branch.place_order.PlaceOrderDraftDTO;
import dto.branch.place_order.PlaceOrderDraftDetailDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.branch.place_order.PlaceOrderDTO;

public interface PlaceOrderService {

	// 발주 내역
    List<PlaceOrderHistoryDTO> getPlaceOrderHistoryList(int branchCode, String startDate, String endDate, String status);
    PlaceOrderHistoryDTO getPlaceOrderDetail(String poNo);
    
    // 발주서 취소
    boolean cancelPlaceOrder(String poNo, String cancelReason);
    
    // 임시 발주서 가져오기 또는 생성
	PlaceOrderDraftDTO findOrCreateInProgressDraft(int branchCode);
	
	// 발주 가능 품목 조회
	List<Map<String, Object>> getSelectableItems(int branchCode, String category, String item, String search);

	// 발주용 카테고리 조회
	List<MaterialGroupDTO> getSelectableCategories(int branchCode);

	// 발주용 품목명 조회
	List<MaterialDTO> getSelectableMaterials(Integer materialGroupId);
	
	// 발주 임시 상세 추가/삭제
	boolean updatePlaceOrderDraftDetail(int branchCode, String action, PlaceOrderDraftDetailDTO detailDTO);
	
	// 안전재고 미달 품목 수
	int getLowStockTotalCount(int branchCode);
	
}