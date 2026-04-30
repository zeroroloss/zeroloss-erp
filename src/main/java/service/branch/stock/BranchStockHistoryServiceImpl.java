package service.branch.stock;

import java.util.List;
import java.util.Map;

import dao.branch.stock.BranchStockHistoryDao;
import dao.branch.stock.BranchStockHistoryDaoImpl;
import dto.BranchStockChangeHistoryDTO;
import dto.BranchStockDisposalHistoryDTO;

public class BranchStockHistoryServiceImpl implements BranchStockHistoryService {
	private BranchStockHistoryDao branchStockHistoryDao;
	
	public BranchStockHistoryServiceImpl() {
		branchStockHistoryDao = new BranchStockHistoryDaoImpl();
	}

	@Override
	public List<BranchStockChangeHistoryDTO> selectStockChangeHistory(Map<String, Object> params) throws Exception {
		return branchStockHistoryDao.selectStockChangeHistory(params);
	}

	@Override
	public int selectStockChangeHistoryCount(Map<String, Object> params) throws Exception {
		return branchStockHistoryDao.selectStockChangeHistoryCount(params);
	}

	@Override
	public List<BranchStockDisposalHistoryDTO> selectDisposalHistory(Map<String, Object> params) throws Exception {
		return branchStockHistoryDao.selectDisposalHistory(params);
	}

	@Override
	public int selectDisposalHistoryCount(Map<String, Object> params) throws Exception {
		return branchStockHistoryDao.selectDisposalHistoryCount(params);
	}

}
