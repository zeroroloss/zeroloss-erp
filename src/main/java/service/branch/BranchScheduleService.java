package service.branch;

import java.util.List;

import dto.branch.hr.BranchScheduleDTO;
import dto.branch.hr.EmployeeDTO;

public interface BranchScheduleService {
	// 직영점 스케줄 추가
	void addBranchSchedule(BranchScheduleDTO schedule) throws Exception;
	BranchScheduleDTO selectSchedule(Integer scheduleId) throws Exception;
	List<EmployeeDTO> selectBranchEmployee() throws Exception;
	
	// 스케줄 리스트 조회
	List<BranchScheduleDTO> searchBranchScheduleList(BranchScheduleDTO schedule) throws Exception;
	
	// 스케줄 수정
	void modifySchedule(BranchScheduleDTO schedule) throws Exception;
	
	// 스케줄 삭제
	void removeSchedule(Integer scheduleId) throws Exception;
	void removeRepeatSchedule(Integer repeatGroupId) throws Exception;
}
