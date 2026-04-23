package dao;

import dto.AccountDTO;

public interface AccountDao {
	void insertAccount(AccountDTO account) throws Exception;
	AccountDTO searchAccount(String login_id) throws Exception;
	void updateLastLoginAt(int accountId) throws Exception;
}
