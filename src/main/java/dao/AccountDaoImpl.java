package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.AccountDTO;
import util.MyBatisSqlSessionFactory;

public class AccountDaoImpl implements AccountDao {
	// 계정 세션 관리
	@Override
	public AccountDTO searchAccount(String loginId) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		AccountDTO account=null;
		try {
			account = sqlSession.selectOne("mapper.account.searchAccount", loginId);
		} catch(Exception e) {
			throw e;
		} finally {
			sqlSession.close();
		}
		return account;
	}
	
	// 로그인 로그
	@Override
	public void updateLastLoginAt(int accountId) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.update("mapper.account.updateLastLoginAt", accountId);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}
	
	// 계정 상태 대시보드
	@Override
	public Integer selectAccountCnt() throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.account.selectAccountCnt");
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}
	
	@Override
	public Integer selectAccountActiveCnt() throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.account.selectAccountActiveCnt");
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}
	
	@Override
	public Integer selectAccountInactiveCnt() throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.account.selectAccountInactiveCnt");
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

	// 계정 권한 관리 리스트 조회
	@Override
	public List<AccountDTO> selectAccountList(AccountDTO account) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		List<AccountDTO> acc = null;
		try {
			acc = sqlSession.selectList("mapper.account.selectAccountList", account);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return acc;
	}

	// 계정 추가
	@Override
	public void insertAccount(AccountDTO account) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.insert("mapper.account.insertAccount", account);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public AccountDTO selectEmployeeByEmpNo(int empNo) throws Exception {
	    try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
	        return sqlSession.selectOne("mapper.account.selectEmployeeByEmpNo", empNo);
	    } catch(Exception e) {
	    	e.printStackTrace();
	    	throw e;
	    } 
	}

	@Override
	public AccountDTO selectAccountByEmpNo(int empNo) throws Exception {
	    try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
	        return sqlSession.selectOne("mapper.account.selectAccountByEmpNo", empNo);
	    } catch(Exception e) {
	    	e.printStackTrace();
	    	throw e;
	    } 
	}

	@Override
	public void toggleAccountStatus(int accountId) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.update("mapper.account.toggleAccountStatus", accountId);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
	    	throw e;
	    } finally {
	    	sqlSession.close();
	    }
	}

	// 계정 수정
	@Override
	public void updateAccount(AccountDTO account) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.update("mapper.account.updateAccount", account);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
	    	throw e;
	    } finally {
	    	sqlSession.close();
	    }
	}
}
