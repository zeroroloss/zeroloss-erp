package service.hq;

import java.util.List;

import dto.hq.branch_stock.BranchDTO;
import dto.hq.branch_stock.BranchStockListDTO;
import dto.hq.branch_stock.BranchStockSearchDTO;
import dto.hq.branch_stock.MaterialDTO;
import dto.hq.branch_stock.MaterialGroupDTO;


public interface BranchStockService {
	List<BranchStockListDTO> findStockList(BranchStockSearchDTO searchDto);
	List<BranchDTO> findBranchList();
	List<MaterialGroupDTO> findMaterialGroupList();
	List<MaterialDTO> findMaterialByCategory(int materialGroupId);
}
