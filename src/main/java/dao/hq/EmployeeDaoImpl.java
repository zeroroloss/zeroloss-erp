package dao.hq;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.hq.hr.EmployeeDTO;
import util.MyBatisSqlSessionFactory;

public class EmployeeDaoImpl implements EmployeeDao {
	// 직원 현황 대시보드
	@Override
	public Integer selectEmpCnt() throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.employee.selectEmpCnt");
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

	@Override
	public Integer selectBranchCnt() throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.employee.selectBranchCnt");
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

	@Override
	public Integer selectNewEmpCnt() throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.employee.selectNewEmpCnt");
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

	// 직원 리스트 조회
	@Override
	public List<EmployeeDTO> selectEmployeeList(EmployeeDTO employee) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		List<EmployeeDTO> emp = null;
		try {
			emp = sqlSession.selectList("mapper.employee.selectEmployeeList", employee);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return emp;
	} 

	// 본사 직원 추가
	@Override
	public void insertEmployee(EmployeeDTO employee) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.insert("mapper.employee.insertEmployee", employee);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public void updateEmployee(EmployeeDTO employee) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.update("mapper.employee.updateEmployee", employee);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}

}
