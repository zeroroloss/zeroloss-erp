package dao.branch.stock;

import java.util.List;
import java.util.Map;

import dto.BranchStockDTO;
import dto.MaterialDTO;
import dto.MaterialGroupDTO;

public interface BranchStockListDao {
	List<MaterialGroupDTO> selectCategoryList(Integer branchCode) throws Exception;
	
	List<MaterialDTO> selectMaterialListByCategory(Map<String, Object> params) throws Exception;
	
	List<BranchStockDTO> selectBranchStockList(Map<String, Object> params) throws Exception;
	
	int selectBranchStockCount(Map<String, Object> params) throws Exception;
}
