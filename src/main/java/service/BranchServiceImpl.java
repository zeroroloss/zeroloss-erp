package service;

import java.util.List;

import dao.BranchDao;
import dao.BranchDaoImpl;
import dto.BranchDTO;
import dto.hq.hr.BranchOptionDTO;

public class BranchServiceImpl implements BranchService {
	private BranchDao branchDao;

	public BranchServiceImpl() {
		branchDao = new BranchDaoImpl();
	}

	@Override
	public List<BranchOptionDTO> searchBranchName() throws Exception {
		List<BranchOptionDTO> branchName = branchDao.selectBranchNameList();
		return branchName;
	}

	@Override
	public List<BranchDTO> getAllBranches() {
		return branchDao.selectAllBranches();
	}

	@Override
	public List<BranchDTO> searchBranchList() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
}
