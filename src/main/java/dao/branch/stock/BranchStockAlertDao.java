package dao.branch.stock;

import java.util.List;

import dto.BranchStockDTO;

public interface BranchStockAlertDao {
	List<BranchStockDTO> selectExpiredStock(int branchCode) throws Exception;

	List<BranchStockDTO> selectUrgentStock(int branchCode) throws Exception;

	List<BranchStockDTO> selectWarningStock(int branchCode) throws Exception;
	
	List<BranchStockDTO> selectEmptyStock(int branchCode) throws Exception;

	List<BranchStockDTO> selectLackStock(int branchCode) throws Exception;
}
