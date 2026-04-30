package dao.hq;

import java.util.List;

import dto.hq.hr.EmployeeDTO;
import dto.hq.hr.HqScheduleDTO;

public interface HqScheduleDao {
	// 스케줄 추가(본사 직원)
	void insertSchedule(HqScheduleDTO schedule) throws Exception;
	HqScheduleDTO selectSchedule(Integer scheduleId) throws Exception;
	List<EmployeeDTO> selectHqEmployee() throws Exception;
	
	// 스케줄 리스트 조회
	List<HqScheduleDTO> selectScheduleList(HqScheduleDTO schedule) throws Exception;
	
	// 중복 확인
	Integer duplicateScdCnt(HqScheduleDTO schedule) throws Exception;
	Integer duplicateScdCntForUpdate(HqScheduleDTO schedule) throws Exception;
	
	// 스케줄 수정
	void updateSchedule(HqScheduleDTO schedule) throws Exception;
	
	// 스케줄 삭제
	void deleteSchedule(Integer scheduleId) throws Exception;
}
