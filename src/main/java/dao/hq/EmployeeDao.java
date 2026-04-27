package dao.hq;

import java.util.List;

import dto.hq.hr.EmployeeDTO;

public interface EmployeeDao {
	// 직원 현황 대시보드
	Integer selectEmpCnt() throws Exception;
	Integer selectBranchCnt() throws Exception;
	Integer selectNewEmpCnt() throws Exception;
	
	// 본사 및 전체 직원 리스트 조회
	List<EmployeeDTO> selectEmployeeList(EmployeeDTO employee) throws Exception;
 	
	// 직원 추가(본사 직원)
	void insertEmployee(EmployeeDTO employee) throws Exception;
	
	// 직원 정보 수정
	void updateEmployee(EmployeeDTO employee) throws Exception;
}
