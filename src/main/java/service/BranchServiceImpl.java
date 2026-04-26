package service;

import java.util.List;

import dao.BranchDao;
import dao.BranchDaoImpl;
import dto.BranchDTO;

public class BranchServiceImpl implements BranchService {
	private BranchDao branchDao;

	public BranchServiceImpl() {
		branchDao = new BranchDaoImpl();
	}

	@Override
	public List<String> searchBranchName() throws Exception {
		List<String> branchName = branchDao.selectBranchNameList();
		return branchName;
	}

	@Override
	public List<BranchDTO> getAllBranches() {
		return branchDao.selectAllBranches();
	}
}
