package dao;

import java.util.List;

import dto.BranchDTO;
import dto.hq.hr.BranchOptionDTO;

public interface BranchDao {
	void insertBranch(BranchDTO branch) throws Exception;
	BranchDTO selectBranch(Integer branchCode) throws Exception;
	List<BranchDTO> selectBranchList() throws Exception;
	List<BranchOptionDTO> selectBranchNameList() throws Exception;
}
