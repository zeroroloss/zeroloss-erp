package service.branch.stock;

import java.util.List;
import java.util.Map;

import dao.branch.stock.BranchStockListDao;
import dao.branch.stock.BranchStockListDaoImpl;
import dto.BranchStockDTO;
import dto.MaterialDTO;
import dto.MaterialGroupDTO;

public class BranchStockServiceImpl implements BranchStockService {
	
	private BranchStockListDao branchStockListDao;
	
	public BranchStockServiceImpl() {
		branchStockListDao = new BranchStockListDaoImpl();
	}

	@Override
	public List<MaterialGroupDTO> selectCategoryList(int branchCode) throws Exception {
		return branchStockListDao.selectCategoryList(branchCode);
	}

	@Override
	public List<MaterialDTO> selectMaterialListByCategory(Map<String, Object> params) throws Exception {
		return branchStockListDao.selectMaterialListByCategory(params);
	}

	@Override
	public List<BranchStockDTO> selectBranchStockList(Map<String, Object> params) throws Exception {
		return branchStockListDao.selectBranchStockList(params);
	}

	@Override
	public int selectBranchStockCount(Map<String, Object> params) throws Exception {
		return branchStockListDao.selectBranchStockCount(params);
	}

}
