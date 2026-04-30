package service.branch.stock;

import java.util.List;
import java.util.Map;

import dto.BranchStockChangeHistoryDTO;
import dto.BranchStockDisposalHistoryDTO;

public interface BranchStockHistoryService {

	List<BranchStockChangeHistoryDTO> selectStockChangeHistory(Map<String, Object> params) throws Exception;
	
	int selectStockChangeHistoryCount(Map<String, Object> params) throws Exception;
	
	List<BranchStockDisposalHistoryDTO> selectDisposalHistory(Map<String, Object> params) throws Exception;
	
	int selectDisposalHistoryCount(Map<String, Object> params) throws Exception;
}
