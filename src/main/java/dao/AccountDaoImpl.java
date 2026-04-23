package dao;

import org.apache.ibatis.session.SqlSession;

import dto.AccountDTO;
import util.MyBatisSqlSessionFactory;

public class AccountDaoImpl implements AccountDao {
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

}
