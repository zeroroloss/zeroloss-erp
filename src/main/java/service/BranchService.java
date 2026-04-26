package service;

import dto.BranchDTO;
import java.util.List;

public interface BranchService {
	List<String> searchBranchName() throws Exception;
	List<BranchDTO> getAllBranches();
}
