package dao.hq;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.hq.branch_stock.BranchRiskSearchDTO;
import dto.hq.branch_stock.BranchRiskSummaryDTO;
import dto.hq.branch_stock.DisposalRiskDTO;
import dto.hq.branch_stock.ExpireRiskDTO;

public class BranchRiskDaoImpl implements BranchRiskDao {

	@Override
	public BranchRiskSummaryDTO selectRiskSummary(SqlSession sqlSession, BranchRiskSearchDTO searchDTO) {
		return sqlSession.selectOne("mapper.hq.branchrisk.selectRiskSummary", searchDTO);
	}

	@Override
	public List<ExpireRiskDTO> selectExpireRiskList(SqlSession sqlSession, BranchRiskSearchDTO searchDTO) {
		return sqlSession.selectList("mapper.hq.branchrisk.selectExpireRiskList", searchDTO);
	}

	@Override
	public List<DisposalRiskDTO> selectDisposalRiskList(SqlSession sqlSession, BranchRiskSearchDTO searchDTO) {
		return sqlSession.selectList("mapper.hq.branchrisk.selectDisposalRiskList", searchDTO);
	}

}
