package dao.branch.place_order;

import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.branch.place_order.PlaceOrderDraftDTO;
import dto.branch.place_order.PlaceOrderDraftDetailDTO;

public class PlaceOrderDraftDAOImpl implements PlaceOrderDraftDAO {
	
    private final String MAPPER_NAMESPACE = "mapper.branch.placeOrderDraftMapper.";

	@Override
	public PlaceOrderDraftDTO findInProgressDraft(SqlSession sqlSession, int branchCode) {
        return sqlSession.selectOne(MAPPER_NAMESPACE + "findInProgressDraft", branchCode);
	}

	@Override
	public void insertDraft(SqlSession sqlSession, PlaceOrderDraftDTO draftDTO) {
		sqlSession.insert(MAPPER_NAMESPACE + "insertDraft", draftDTO);
	}

	@Override
	public List<PlaceOrderDraftDetailDTO> findDraftDetails(SqlSession sqlSession, int draftId) {
		return sqlSession.selectList(MAPPER_NAMESPACE + "findDraftDetails", draftId);
	}

	@Override
	public List<PlaceOrderDraftDetailDTO> findLowStockMaterials(SqlSession sqlSession, int branchCode) {
		return sqlSession.selectList(MAPPER_NAMESPACE + "findLowStockMaterials", branchCode);
	}

	@Override
	public void insertDraftDetail(SqlSession sqlSession, PlaceOrderDraftDetailDTO detailDTO) {
		sqlSession.insert(MAPPER_NAMESPACE + "insertDraftDetail", detailDTO);
	}

	@Override
	public int deleteDraftDetail(SqlSession sqlSession, int draftId, String materialCode) {
		Map<String, Object> params = new LinkedHashMap<>();
		params.put("draftId", draftId);
		params.put("materialCode", materialCode);
		return sqlSession.delete(MAPPER_NAMESPACE + "deleteDraftDetail", params);
	}

	@Override
	public int updateDraftDetailQty(SqlSession sqlSession, int draftId, String materialCode, int requestedQty) {
		Map<String, Object> params = new LinkedHashMap<>();
		params.put("draftId", draftId);
		params.put("materialCode", materialCode);
		params.put("requestedQty", requestedQty);
		return sqlSession.update(MAPPER_NAMESPACE + "updateDraftDetailQty", params);
	}

	@Override
	public List<Map<String, Object>> findSelectableItems(SqlSession sqlSession, int branchCode, int draftId) {
		Map<String, Object> params = new LinkedHashMap<>();
		params.put("branchCode", branchCode);
		params.put("draftId", draftId);
		return sqlSession.selectList(MAPPER_NAMESPACE + "findSelectableItems", params);
	}

}
