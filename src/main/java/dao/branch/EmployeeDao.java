package dao.branch;

import java.util.List;

import dto.branch.hr.EmployeeDTO;

public interface EmployeeDao {
	// 직원 현황 대시보드
	Integer selectEmpCnt(Integer branchCode) throws Exception;
	Integer selectHqEmpCnt(Integer branchCode) throws Exception;
	Integer selectPTMCnt(Integer branchCode) throws Exception;
	
	// 직원 리스트 조회
	List<EmployeeDTO> selectEmployeeList(Integer branchCode) throws Exception;
 	
	// 직원 추가(알바생)
	void insertEmployee(EmployeeDTO employee) throws Exception;
	EmployeeDTO selectEmployee(Integer empNo) throws Exception;
	EmployeeDTO selectEmployeeByPhone(EmployeeDTO employee) throws Exception;
	
	// 직원 정보 수정
	void updateEmployee(EmployeeDTO employee) throws Exception;
	
	// 메인 페이지 오늘 근무 직원 수
	Integer selectTodayEmpCnt(Integer branchCode) throws Exception;
}

