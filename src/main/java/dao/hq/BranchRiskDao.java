package dao.hq;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.hq.branch_stock.BranchRiskSearchDTO;
import dto.hq.branch_stock.BranchRiskSummaryDTO;
import dto.hq.branch_stock.DisposalRiskDTO;
import dto.hq.branch_stock.ExpireRiskDTO;

public interface BranchRiskDao {
	BranchRiskSummaryDTO selectRiskSummary(SqlSession sqlSession, BranchRiskSearchDTO searchDTO);
	List<ExpireRiskDTO> selectExpireRiskList(SqlSession sqlSession, BranchRiskSearchDTO searchDTO);
	List<DisposalRiskDTO> selectDisposalRiskList(SqlSession sqlSession, BranchRiskSearchDTO searchDTO);
	
}
