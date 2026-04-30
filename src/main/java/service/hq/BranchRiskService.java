package service.hq;

import java.util.List;

import dto.hq.branch_stock.BranchRiskSearchDTO;
import dto.hq.branch_stock.BranchRiskSummaryDTO;
import dto.hq.branch_stock.DisposalRiskDTO;
import dto.hq.branch_stock.ExpireRiskDTO;

public interface BranchRiskService {
	
	BranchRiskSummaryDTO getRiskSummary(BranchRiskSearchDTO searchDTO);
	List<ExpireRiskDTO> getExpireRiskList(BranchRiskSearchDTO searchDTO);
	List<DisposalRiskDTO> getDisposalRiskList(BranchRiskSearchDTO searchDTO);
}
