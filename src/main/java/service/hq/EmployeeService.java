package service.hq;

import java.util.List;

import dto.hq.hr.EmployeeDTO;

public interface EmployeeService {
	// 직원 현황 대시보드
	Integer selectEmpCnt() throws Exception;
	Integer selectBranchCnt() throws Exception;
	Integer selectNewEmpCnt() throws Exception;
	
	// 전체 직원 조회
	List<EmployeeDTO> searchEmployeeList(EmployeeDTO employee) throws Exception;
	
	// 본사 직원 추가
	void addEmployee(EmployeeDTO employee) throws Exception;
	
	// 직원 정보 수정
	void modifyEmployee(EmployeeDTO employee) throws Exception;
}
