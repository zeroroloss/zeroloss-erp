package service.branch;

import java.util.List;

import dto.branch.hr.EmployeeDTO;

public interface EmployeeService {
	// 직원 현황 대시보드
	Integer selectEmpCnt(Integer branchCode) throws Exception;
	Integer selectHqEmpCnt(Integer branchCode) throws Exception;
	Integer selectPTMCnt(Integer branchCode) throws Exception;
	
	// 전체 직원 조회
	List<EmployeeDTO> searchEmployeeList(Integer branchCode) throws Exception;
	
	// 본사 직원 추가
	void addEmployee(EmployeeDTO employee) throws Exception;
	EmployeeDTO selectEmployee(Integer empNo) throws Exception;
	EmployeeDTO selectEmployeeByPhone(EmployeeDTO employee) throws Exception;
	
	// 직원 정보 수정
	void modifyEmployee(EmployeeDTO employee) throws Exception;
}
