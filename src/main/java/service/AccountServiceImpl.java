package service;

import dao.AccountDao;
import dao.AccountDaoImpl;
import dto.Account;

public class AccountServiceImpl implements AccountService {
	private AccountDao accountDao;

	public AccountServiceImpl() {
		accountDao = new AccountDaoImpl();
	}

	@Override
	public Account login(String loginId, String password) throws Exception {
		Account acc = accountDao.selectAccount(loginId);
		if(acc==null) throw new Exception("존재하지 않는 아이디입니다.");
		if(!"ACTIVE".equals(acc.getStatus())) throw new Exception("비활성화된 계정입니다.");

		// 평문 비밀번호 비교
		String inputPw = password == null? "" : password.trim();
		String dbPw = acc.getPassword() == null? "" : acc.getPassword();
		
		if(!dbPw.equals(inputPw))throw new Exception("비밀번호가 일치하지 않습니다.");
		accountDao.updateLastLoginAt(acc.getAccountId());
		return acc;
	}
}