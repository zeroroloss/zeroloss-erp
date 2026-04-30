package dao.branch.stock;

import java.math.BigDecimal;
import java.util.Map;

import dto.BranchStockChangeHistoryDTO;
import dto.BranchStockDisposalHistoryDTO;

public interface BranchDisposalDao {
	// 폐기 후 after_qty 조회용
	BigDecimal selectCurrentQty(String branchStockCode) throws Exception;
	
	// 폐기 등록
	void insertStockChangeHistory(BranchStockChangeHistoryDTO dto) throws Exception;
	
	// 폐기 이력 등록
	void insertDisposalHistory(BranchStockDisposalHistoryDTO dto) throws Exception;
	
	// 재고 수량 차감
	int updateBranchStockQty(Map<String, Object> params) throws Exception;
}
