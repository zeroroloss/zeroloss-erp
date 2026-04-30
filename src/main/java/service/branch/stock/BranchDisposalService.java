package service.branch.stock;

import java.math.BigDecimal;
import java.util.Map;

import dto.BranchStockChangeHistoryDTO;
import dto.BranchStockDisposalHistoryDTO;

public interface BranchDisposalService {
	BigDecimal selectCurrentQty(String branchStockCode) throws Exception;
	
	void insertStockChangeHistory(BranchStockChangeHistoryDTO dto) throws Exception;
	
	void insertDisposalHistory(BranchStockDisposalHistoryDTO dto) throws Exception;
	
	int updateBranchStockQty(Map<String, Object> params) throws Exception;
}
