package dao.branch;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.branch.hr.EmployeeDTO;
import util.MyBatisSqlSessionFactory;

public class EmployeeDaoImpl implements EmployeeDao {
	// 직원 현황 대시보드
	@Override
	public Integer selectEmpCnt(Integer branchCode) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.branch.employee.selectEmpCnt", branchCode);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

	@Override
	public Integer selectHqEmpCnt(Integer branchCode) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.branch.employee.selectHqEmpCnt", branchCode);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

	@Override
	public Integer selectPTMCnt(Integer branchCode) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.branch.employee.selectPTMCnt", branchCode);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

	@Override
	public List<EmployeeDTO> selectEmployeeList(Integer branchCode) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		List<EmployeeDTO> emp = null;
		try {
			emp = sqlSession.selectList("mapper.branch.employee.selectEmployeeList", branchCode);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return emp;
	}

	@Override
	public void insertEmployee(EmployeeDTO employee) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.insert("mapper.branch.employee.insertEmployee", employee);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public EmployeeDTO selectEmployee(Integer empNo) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return sqlSession.selectOne("mapper.branch.employee.selectEmployee", empNo);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public EmployeeDTO selectEmployeeByPhone(EmployeeDTO employee) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return sqlSession.selectOne("mapper.branch.employee.selectEmployeeByPhone", employee);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void updateEmployee(EmployeeDTO employee) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.update("mapper.branch.employee.updateEmployee", employee);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public Integer selectTodayEmpCnt(Integer branchCode) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.branch.employee.selectTodayEmpCnt", branchCode);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

}
