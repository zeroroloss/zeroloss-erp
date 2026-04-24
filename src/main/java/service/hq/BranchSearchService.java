package service.hq;

import dto.HqBranchSearchDTO;
import java.util.List;

public interface BranchSearchService {
    List<HqBranchSearchDTO> searchBranches(String region, String keyword);
    void createBranch(HqBranchSearchDTO branchDTO) throws Exception;
    void updateBranch(HqBranchSearchDTO branchDTO) throws Exception;
    void deleteBranch(String id) throws Exception;
}
