package dao.branch;

import java.util.List;

import dto.branch.hr.EmployeeDTO;

public interface EmployeeDao {
	// 직원 현황 대시보드
	Integer selectEmpCnt() throws Exception;
	Integer selectHqEmpCnt() throws Exception;
	Integer selectPTMCnt() throws Exception;
	
	// 직원 리스트 조회
	List<EmployeeDTO> selectEmployeeList(EmployeeDTO employee) throws Exception;
 	
	// 직원 추가(알바생)
	void insertEmployee(EmployeeDTO employee) throws Exception;
	EmployeeDTO selectEmployee(Integer empNo) throws Exception;
	EmployeeDTO selectEmployeeByPhone(EmployeeDTO employee) throws Exception;
	
	// 직원 정보 수정
	void updateEmployee(EmployeeDTO employee) throws Exception;
}

