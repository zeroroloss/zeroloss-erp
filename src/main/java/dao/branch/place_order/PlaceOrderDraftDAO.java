package dao.branch.place_order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.MaterialDTO;
import dto.MaterialGroupDTO;
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
	
	// 안전재고 미달 품목 전체 개수
	int countLowStockMaterials(SqlSession sqlSession, int branchCode);
	
	// draftDetail 삽입
	void insertDraftDetail(SqlSession sqlSession, PlaceOrderDraftDetailDTO detailDTO);

	// draftDetail 모두 삭제
	int deleteDraftDetails(SqlSession sqlSession, int draftId);

	// draftDetail 단일 삭제
	int deleteDraftDetails(SqlSession sqlSession, int draftId, String materialCode);
	
	// draftDetail 요청수량 업데이트
	int updateDraftDetailQty(SqlSession sqlSession, int draftId, String materialCode, int requestedQty);

	// 팝업용 전체 품목 조회 (드래프트 포함 상태 + 재고/안전재고)
	List<Map<String, Object>> findSelectableItems(SqlSession sqlSession, int branchCode, int draftId);

	// 발주용 카테고리 조회
	List<MaterialGroupDTO> findSelectableCategories(SqlSession sqlSession, int branchCode);

	// 발주용 품목명 조회
	List<MaterialDTO> findSelectableMaterials(SqlSession sqlSession, Integer materialGroupId);

	// 드래프트 전송 후 상태 업데이트 (po_id 연결 + 상태 변경)
	int updateDraftStatusAfterSend(SqlSession sqlSession, int draftId, int poId, String status);

}
