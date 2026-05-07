package service;

import dto.BranchDTO;
import java.util.List;

import dto.hq.hr.BranchOptionDTO;

public interface BranchService {
	List<BranchOptionDTO> searchBranchName() throws Exception;
	List<BranchDTO> searchBranchList() throws Exception;
	List<BranchDTO> getAllBranches();
}
