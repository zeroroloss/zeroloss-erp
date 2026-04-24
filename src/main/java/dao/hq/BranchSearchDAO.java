package dao.hq;

import dto.HqBranchSearchDTO;
import java.util.List;

public interface BranchSearchDAO {
    List<HqBranchSearchDTO> searchBranches(String region, String keyword);
    Integer getMaxBranchCode(String regionCode) throws Exception;
    void createBranch(HqBranchSearchDTO branchDTO) throws Exception;
    void updateBranch(HqBranchSearchDTO branchDTO) throws Exception;
    void deleteBranch(String id) throws Exception;
}