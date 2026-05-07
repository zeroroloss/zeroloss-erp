package dao;

import java.util.List;

import dto.AccountDTO;
import dto.AccountEmployeeDTO;

public interface AccountDao {
	// 계정 세션 관리
	AccountDTO searchAccount(String loginId) throws Exception;
	// 로그인 로그
	void updateLastLoginAt(int accountId) throws Exception;
	
	// 계정 상태 대시보드
	Integer selectAccountCnt() throws Exception;
	Integer selectAccountActiveCnt() throws Exception;
	Integer selectAccountInactiveCnt() throws Exception;
	
	// 본사 권한 관리 리스트 조회
	List<AccountDTO> selectAccountList(AccountDTO account) throws Exception;

	// 계정 추가
	void insertAccount(AccountDTO account) throws Exception;
	AccountEmployeeDTO selectAvailableEmployee(Integer empNo) throws Exception;
	AccountDTO selectEmployeeByEmpNo(int empNo) throws Exception;
	AccountDTO selectAccountByEmpNo(int empNo) throws Exception;
	AccountDTO selectACcountByLoginId(String loginId) throws Exception;
	void toggleAccountStatus(int accountId) throws Exception;
	
	// 계정 수정
	void updateAccount(AccountDTO account) throws Exception;
}
