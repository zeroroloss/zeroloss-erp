package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.BranchDTO;
import dto.hq.hr.BranchOptionDTO;
import util.MyBatisSqlSessionFactory;

public class BranchDaoImpl implements BranchDao {
	@Override
	public void insertBranch(BranchDTO branch) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			sqlSession.insert("mapper.BranchMapper.insertBranch", branch);
			sqlSession.commit();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public BranchDTO selectBranch(Integer branchCode) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return sqlSession.selectOne("mapper.BranchMapper.selectBranch", branchCode);
		}
	}

	@Override
	public List<BranchOptionDTO> selectBranchNameList() throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		List<BranchOptionDTO> branchNameList = null;
		try {
			branchNameList = sqlSession.selectList("mapper.branchoption.selectBranchNameList");
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return branchNameList;
	}

	@Override
	public List<BranchDTO> selectBranchList() throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		List<BranchDTO> branchList = null;
		try {
			branchList = sqlSession.selectList("mapper.branch.selectBranchNameList");
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return branchList;
	}

	@Override
	public List<BranchDTO> selectAllBranches() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return sqlSession.selectList("mapper.BranchMapper.selectAllBranches");
		}
	}
}
