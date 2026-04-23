package service;

import dto.AccountDTO;

public interface AccountService {
	AccountDTO login(String loginId, String password) throws Exception;
}
