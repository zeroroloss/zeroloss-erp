package dao.branch.stock;

import java.util.List;

import dto.branch.stock.BranchSafetyStockRowDTO;

public interface BranchSafetyStockDao {
	List<BranchSafetyStockRowDTO> selectSafetyStocks(int branchCode, String categoryName, String itemName) throws Exception;
	int updateSafetyStock(int branchCode, String materialCode, java.math.BigDecimal safeStockQty) throws Exception;
}