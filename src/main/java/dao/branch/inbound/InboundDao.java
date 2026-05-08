package dao.branch.inbound;

import java.util.Map;
import java.math.BigDecimal;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.branch.inbound.InboundProcessingDTO;

public interface InboundDao {

	List<InboundProcessingDTO> findInboundList(SqlSession sqlSession, int branchCode);

	Map<String, Object> findOutboundHeaderForConfirm(SqlSession sqlSession, String poNo, int branchCode);

	int insertBranchStockInbound(SqlSession sqlSession, int hqOutboundNo, int branchCode, Map<String, Object> keyHolder);

	Map<String, Object> findOutboundDetailForConfirm(SqlSession sqlSession, int hqOutboundDetailId, int hqOutboundNo, int branchCode);

	int insertBranchStockInboundDetail(SqlSession sqlSession, int inboundId, int hqOutboundDetailId, java.math.BigDecimal qty,
			String branchStockCode);

	int insertBranchStockInboundHistory(SqlSession sqlSession, String branchStockCode, java.math.BigDecimal qty);

	int updatePlaceOrderStatusCompleted(SqlSession sqlSession, String poNo, int branchCode);

	int insertBranchStock(SqlSession sqlSession, Map<String, Object> params);
	
	int updateBranchStockCode(SqlSession sqlSession, Long branchStockId, String branchStockCode);
}
