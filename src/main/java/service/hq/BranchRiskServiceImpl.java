package service.hq;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dao.hq.BranchRiskDao;
import dao.hq.BranchRiskDaoImpl;
import dto.hq.branch_stock.BranchRiskSearchDTO;
import dto.hq.branch_stock.BranchRiskSummaryDTO;
import dto.hq.branch_stock.DisposalRiskDTO;
import dto.hq.branch_stock.ExpireRiskDTO;
import util.MyBatisSqlSessionFactory;

public class BranchRiskServiceImpl implements BranchRiskService {

	private BranchRiskDao dao = new BranchRiskDaoImpl();
	
	@Override
	public BranchRiskSummaryDTO getRiskSummary(BranchRiskSearchDTO searchDTO) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return dao.selectRiskSummary(sqlSession, searchDTO);
		}
	}

	@Override
	public List<ExpireRiskDTO> getExpireRiskList(BranchRiskSearchDTO searchDTO) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return dao.selectExpireRiskList(sqlSession, searchDTO);
		}
	}

	@Override
	public List<DisposalRiskDTO> getDisposalRiskList(BranchRiskSearchDTO searchDTO) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return dao.selectDisposalRiskList(sqlSession, searchDTO);
		}
	}

}
