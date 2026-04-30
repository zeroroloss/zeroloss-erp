package service.branch.stock;

import java.util.List;
import java.util.Map;

import dto.BranchStockDTO;
import dto.MaterialDTO;
import dto.MaterialGroupDTO;

public interface BranchStockService {
	 List<MaterialGroupDTO> selectCategoryList(int branchCode) throws Exception;

     List<MaterialDTO> selectMaterialListByCategory(Map<String, Object> params) throws Exception;

     List<BranchStockDTO> selectBranchStockList(Map<String, Object> params) throws Exception;
     
     int selectBranchStockCount(Map<String, Object> params) throws Exception;
}
