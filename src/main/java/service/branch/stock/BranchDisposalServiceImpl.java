package service.branch.stock;

import java.math.BigDecimal;
import java.util.Map;

import dao.branch.stock.BranchDisposalDao;
import dao.branch.stock.BranchDisposalDaoImpl;
import dto.BranchStockChangeHistoryDTO;
import dto.BranchStockDisposalHistoryDTO;

public class BranchDisposalServiceImpl implements BranchDisposalService {
	private BranchDisposalDao branchDisposalDao;
	
	public BranchDisposalServiceImpl() {
		branchDisposalDao = new BranchDisposalDaoImpl();
	}

	@Override
	public BigDecimal selectCurrentQty(String branchStockCode) throws Exception {
		return branchDisposalDao.selectCurrentQty(branchStockCode);
	}

	@Override
	public void insertStockChangeHistory(BranchStockChangeHistoryDTO dto) throws Exception {
		branchDisposalDao.insertStockChangeHistory(dto);

	}

	@Override
	public void insertDisposalHistory(BranchStockDisposalHistoryDTO dto) throws Exception {
		branchDisposalDao.insertDisposalHistory(dto);

	}

	@Override
	public int updateBranchStockQty(Map<String, Object> params) throws Exception {
		return branchDisposalDao.updateBranchStockQty(params);
	}

}
