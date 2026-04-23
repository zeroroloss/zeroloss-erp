package service;

import dao.AccountDao;
import dao.AccountDaoImpl;
import dto.AccountDTO;

public class AccountServiceImpl implements AccountService {
	private AccountDao accountDao;

	public AccountServiceImpl() {
		accountDao = new AccountDaoImpl();
	}
		
		@Override
		public AccountDTO login(String loginId, String password) throws Exception {
		    AccountDTO acc = accountDao.selectAccount(loginId);
		    if(acc == null) throw new Exception("존재하지 않는 아이디입니다.");
		    if(!"ACTIVE".equals(acc.getStatus())) throw new Exception("비활성화된 계정입니다.");

		    String inputPw = password == null ? "" : password.trim();
		    String dbPw = acc.getPassword() == null ? "" : acc.getPassword().trim();

		    System.out.println("입력 아이디 = [" + loginId + "]");
		    System.out.println("입력 비밀번호 = [" + inputPw + "]");
		    System.out.println("DB 비밀번호 = [" + dbPw + "]");
		    System.out.println("equals 결과 = " + dbPw.equals(inputPw));

		    if(!dbPw.equals(inputPw)) throw new Exception("비밀번호가 일치하지 않습니다.");

		    System.out.println("로그인 검증 통과");
		    // accountDao.updateLastLoginAt(acc.getAccountId());
		    return acc;
		}
//	}
}