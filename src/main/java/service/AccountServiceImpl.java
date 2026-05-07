package service;

import java.util.List;

import dao.AccountDao;
import dao.AccountDaoImpl;
import dto.AccountDTO;
import dto.AccountEmployeeDTO;

public class AccountServiceImpl implements AccountService {
	private AccountDao accountDao;

	public AccountServiceImpl() {
		accountDao = new AccountDaoImpl();
	}
		
	@Override
	public AccountDTO login(String loginId, String password) throws Exception {
	    AccountDTO acc = accountDao.searchAccount(loginId);
	    if(acc == null) throw new Exception("존재하지 않는 아이디입니다.");
	    if(!"ACTIVE".equals(acc.getStatus())) throw new Exception("비활성화된 계정입니다.");

	    String inputPw = password == null ? "" : password.trim();
	    String dbPw = acc.getPassword() == null ? "" : acc.getPassword().trim();

	    if(!dbPw.equals(inputPw)) throw new Exception("비밀번호가 일치하지 않습니다.");

	    accountDao.updateLastLoginAt(acc.getAccountId());
	    return acc;
	}

	@Override
	public Integer selectAccountCnt() throws Exception {
		Integer cnt = accountDao.selectAccountCnt();
		return cnt;
	}

	@Override
	public Integer selectAccountActiveCnt() throws Exception {
		Integer cnt = accountDao.selectAccountActiveCnt();
		return cnt;
	}

	@Override
	public Integer selectAccountInactiveCnt() throws Exception {
		Integer cnt = accountDao.selectAccountInactiveCnt();
		return cnt;
	}
	
	@Override
	public List<AccountDTO> searchAccountList(AccountDTO account) throws Exception {
		List<AccountDTO> acc = accountDao.selectAccountList(account);
		return acc;
	}

	@Override
	public void addAccount(AccountDTO account) throws Exception {
		accountDao.insertAccount(account);
	}

	@Override
	public AccountDTO selectEmployeeByEmpNo(int empNo) throws Exception {
		return accountDao.selectEmployeeByEmpNo(empNo);
	}

	@Override
	public AccountDTO selectAccountByEmpNo(int empNo) throws Exception {
		return accountDao.selectAccountByEmpNo(empNo);
	}

	@Override
	public void toggleAccountStatus(int accountId) throws Exception {
		accountDao.toggleAccountStatus(accountId);
		
	}

<<<<<<< Updated upstream
	@Override
	public void modifyAccount(AccountDTO account) throws Exception {
		accountDao.updateAccount(account);
	}
=======
		@Override
		public void addAccount(AccountDTO account) throws Exception {
			accountDao.insertAccount(account);
		}

		@Override
		public AccountDTO selectEmployeeByEmpNo(int empNo) throws Exception {
			return accountDao.selectEmployeeByEmpNo(empNo);
		}

		@Override
		public AccountDTO selectAccountByEmpNo(int empNo) throws Exception {
			return accountDao.selectAccountByEmpNo(empNo);
		}

		@Override
		public void toggleAccountStatus(int accountId) throws Exception {
			accountDao.toggleAccountStatus(accountId);
			
		}

		@Override
		public void modifyAccount(AccountDTO account) throws Exception {
			accountDao.updateAccount(account);
		}

		@Override
		public AccountDTO selectAccountByLoginId(String loginId) throws Exception {
			return accountDao.selectACcountByLoginId(loginId);
		}

		@Override
		public AccountEmployeeDTO selectAvailableEmployee(Integer empNo) throws Exception {
			return accountDao.selectAvailableEmployee(empNo);
		}
>>>>>>> Stashed changes
}