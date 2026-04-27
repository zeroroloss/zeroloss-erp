package service;

import java.util.List;

import dto.AccountDTO;

public interface AccountService {
	AccountDTO login(String loginId, String password) throws Exception;
	Integer selectAccountCnt() throws Exception;
	Integer selectAccountActiveCnt() throws Exception;
	Integer selectAccountInactiveCnt() throws Exception;
	List<AccountDTO> searchAccountList(AccountDTO account) throws Exception;
	void addAccount(AccountDTO account) throws Exception;
	AccountDTO selectEmployeeByEmpNo(int empNo) throws Exception;
	AccountDTO selectAccountByEmpNo(int empNo) throws Exception;
	void toggleAccountStatus(int accountId) throws Exception;
	void modifyAccount(AccountDTO account) throws Exception;
}
