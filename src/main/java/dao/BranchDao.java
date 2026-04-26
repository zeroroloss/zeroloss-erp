package dao;

import java.util.List;

import dto.BranchDTO;

public interface BranchDao {
	void insertBranch(BranchDTO branch) throws Exception;
	BranchDTO selectBranch(Integer branchCode) throws Exception;
	List<String> selectBranchNameList() throws Exception;
	List<BranchDTO> selectAllBranches();
}
