package service.hq;

import java.util.List;

import dto.hq.hr.EmployeeDTO;
import dto.hq.hr.HqScheduleDTO;

public interface HqScheduleService {
	// 본사 스케줄 추가
	void addSchedule(HqScheduleDTO schedule) throws Exception;
	HqScheduleDTO selectSchedule(Integer scheduleId) throws Exception;
	List<EmployeeDTO> selectHqEmployee() throws Exception;
	
	// 스케줄 리스트 조회
	List<HqScheduleDTO> searchScheduleList(HqScheduleDTO schedule) throws Exception;
	
	// 스케줄 수정
	void modifySchedule(HqScheduleDTO schedule) throws Exception;
	
	// 스케줄 삭제
	void removeSchedule(Integer scheduleId) throws Exception;
}
