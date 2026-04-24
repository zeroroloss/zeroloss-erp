package service;

import java.util.List;

import dto.AccountDTO;

public interface AccountService {
	AccountDTO login(String loginId, String password) throws Exception;
	Integer selectAccountCnt() throws Exception;
	Integer selectAccountActiveCnt() throws Exception;
	Integer selectAccountInactiveCnt() throws Exception;
	List<AccountDTO> searchAccountList(AccountDTO account) throws Exception;
}
