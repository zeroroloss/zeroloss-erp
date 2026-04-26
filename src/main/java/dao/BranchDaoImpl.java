package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.BranchDTO;
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
	public List<String> selectBranchNameList() throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return sqlSession.selectList("mapper.BranchMapper.selectBranchNameList");
		}
	}

	@Override
	public List<BranchDTO> selectAllBranches() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return sqlSession.selectList("mapper.BranchMapper.selectAllBranches");
		}
	}
}
