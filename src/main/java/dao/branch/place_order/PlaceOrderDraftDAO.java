package dao.branch.place_order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.branch.place_order.PlaceOrderDraftDTO;
import dto.branch.place_order.PlaceOrderDraftDetailDTO;

public interface PlaceOrderDraftDAO {

	// IN_PROGESS 상태의 draft 조회
	PlaceOrderDraftDTO findInProgressDraft(SqlSession sqlSession, int branchCode);
	
	// draft 삽입
	void insertDraft(SqlSession sqlSession, PlaceOrderDraftDTO draftDTO);
	
	// draftDetail 리스트 조회
	List<PlaceOrderDraftDetailDTO> findDraftDetails(SqlSession sqlSession, int draftId);
	
	// 안전재고 미달 품목 조회 (LOW_STOCK) 
	List<PlaceOrderDraftDetailDTO> findLowStockMaterials(SqlSession sqlSession, int branchCode);
	
	// draftDetail 삽입
	void insertDraftDetail(SqlSession sqlSession, PlaceOrderDraftDetailDTO detailDTO);

	// draftDetail 삭제
	int deleteDraftDetail(SqlSession sqlSession, int draftId, String materialCode);

	// draftDetail 요청수량 업데이트
	int updateDraftDetailQty(SqlSession sqlSession, int draftId, String materialCode, int requestedQty);

	// 팝업용 전체 품목 조회 (드래프트 포함 상태 + 재고/안전재고)
	List<Map<String, Object>> findSelectableItems(SqlSession sqlSession, int branchCode, int draftId);
	
}
