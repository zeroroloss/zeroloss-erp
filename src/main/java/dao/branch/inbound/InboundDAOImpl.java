package dao.branch.inbound;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.branch.inbound.InboundProcessingDTO;

public class InboundDAOImpl implements InboundDao {
	
	private static final String MAPPER_NAMESPACE = "mapper.branch.inboundMapper.";

	@Override
	public List<InboundProcessingDTO> findInboundList(SqlSession sqlSession, int branchCode) {
		return sqlSession.selectList(MAPPER_NAMESPACE + "selectInboundsToProcess", branchCode);
	}

	@Override
	public Map<String, Object> findOutboundHeaderForConfirm(SqlSession sqlSession, String poNo, int branchCode) {
		Map<String, Object> params = new HashMap<>();
		params.put("poNo", poNo);
		params.put("branchCode", branchCode);
		return sqlSession.selectOne(MAPPER_NAMESPACE + "selectOutboundHeaderForConfirm", params);
	}

	@Override
	public int insertBranchStockInbound(SqlSession sqlSession, int hqOutboundNo, int branchCode, Map<String, Object> keyHolder) {
		Map<String, Object> params = new HashMap<>();
		params.put("hqOutboundNo", hqOutboundNo);
		params.put("branchCode", branchCode);
		int inserted = sqlSession.insert(MAPPER_NAMESPACE + "insertBranchStockInbound", params);
		keyHolder.put("inboundId", params.get("inboundId"));
		return inserted;
	}

	@Override
	public Map<String, Object> findOutboundDetailForConfirm(SqlSession sqlSession, int hqOutboundDetailId, int hqOutboundNo,
			int branchCode) {
		Map<String, Object> params = new HashMap<>();
		params.put("hqOutboundDetailId", hqOutboundDetailId);
		params.put("hqOutboundNo", hqOutboundNo);
		params.put("branchCode", branchCode);
		return sqlSession.selectOne(MAPPER_NAMESPACE + "selectOutboundDetailForConfirm", params);
	}

	@Override
	public int insertBranchStockInboundDetail(SqlSession sqlSession, int inboundId, int hqOutboundDetailId,
			BigDecimal qty, String branchStockCode) {
		Map<String, Object> params = new HashMap<>();
		params.put("inboundId", inboundId);
		params.put("hqOutboundDetailId", hqOutboundDetailId);
		params.put("qty", qty);
		params.put("branchStockCode", branchStockCode);
		return sqlSession.insert(MAPPER_NAMESPACE + "insertBranchStockInboundDetail", params);
	}

	@Override
	public int insertBranchStockInboundHistory(SqlSession sqlSession, String branchStockCode, BigDecimal qty) {
		Map<String, Object> params = new HashMap<>();
		params.put("branchStockCode", branchStockCode);
		params.put("qty", qty);
		return sqlSession.insert(MAPPER_NAMESPACE + "insertBranchStockInboundHistory", params);
	}

	@Override
	public int updatePlaceOrderStatusCompleted(SqlSession sqlSession, String poNo, int branchCode) {
		Map<String, Object> params = new HashMap<>();
		params.put("poNo", poNo);
		params.put("branchCode", branchCode);
		return sqlSession.update(MAPPER_NAMESPACE + "updatePlaceOrderStatusCompleted", params);
	}

	@Override
	public int insertBranchStock(SqlSession sqlSession, String branchStockCode, int branchCode, 
									String materialCode, String expireDate, BigDecimal qty) {

	    Map<String, Object> params = new HashMap<>();
	    params.put("branchStockCode", branchStockCode);
	    params.put("branchCode", branchCode);
	    params.put("materialCode", materialCode);
	    params.put("expireDate", expireDate);
	    params.put("qty", qty);

	    return sqlSession.update(MAPPER_NAMESPACE + "insertBranchStock", params);
	}

}
