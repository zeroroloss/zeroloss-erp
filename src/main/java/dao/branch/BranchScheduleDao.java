package dao.branch;

import java.util.List;

import dto.branch.hr.BranchScheduleDTO;
import dto.branch.hr.EmployeeDTO;

public interface BranchScheduleDao {
	// 스케줄 추가(알바생)
	void insertSchedule(BranchScheduleDTO schedule) throws Exception;
	BranchScheduleDTO selectSchedule(Integer scheduleId) throws Exception;
	List<EmployeeDTO> selectBranchEmployee() throws Exception;
	
	// 스케줄 리스트 조회
	List<BranchScheduleDTO> selectBranchScheduleList(BranchScheduleDTO schedule) throws Exception;
	
	// 중복 확인
	Integer duplicateScdCnt(BranchScheduleDTO schedule) throws Exception;
	Integer duplicateScdCntForUpdate(BranchScheduleDTO schedule) throws Exception;
	
	// 스케줄 수정
	void updateSchedule(BranchScheduleDTO schedule) throws Exception;
	
	// 스케줄 삭제
	void deleteSchedule(Integer scheduleId) throws Exception;
	void deleteRepeatSchedule(Integer repeatGroupId) throws Exception;
}
