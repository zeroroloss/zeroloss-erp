package service;

import dto.Account;

public interface AccountService {
	Account login(String loginId, String password) throws Exception;
}
