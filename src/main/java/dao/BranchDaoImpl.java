package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.BranchDTO;
import dto.hq.hr.BranchOptionDTO;
import util.MyBatisSqlSessionFactory;

public class BranchDaoImpl implements BranchDao {
	@Override
	public void insertBranch(BranchDTO branch) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.insert("mapper.branch.insertBranch", branch);
			sqlSession.commit();
		} catch(Exception e) {
			e.printStackTrace();
			sqlSession.rollback();
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public BranchDTO selectBranch(Integer branchCode) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		BranchDTO branch = null;
		try {
			branch = sqlSession.selectOne("mapper.branch.selectBranch", branchCode);
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			sqlSession.close();
		}
		return branch;
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
}
