package service.branch.sales;

import dto.RankDTO;

import java.util.List;

public interface BranchSalesRankService {
    List<RankDTO> getTop10(String branchCode, String rankType, String sort, String startDate, String endDate);
    List<RankDTO> getWorst10(String branchCode, String rankType, String sort, String startDate, String endDate);
}
