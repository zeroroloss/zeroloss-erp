package dao;

import dto.Account;

public interface AccountDao {
	void insertAccount(Account account) throws Exception;
	Account selectAccount(String login_id) throws Exception;
	void updateLastLoginAt(int accountId) throws Exception;
}
