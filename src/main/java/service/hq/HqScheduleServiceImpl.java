package service.hq;

import java.util.List;

import dao.hq.EmployeeDao;
import dao.hq.EmployeeDaoImpl;
import dao.hq.HqScheduleDao;
import dao.hq.HqScheduleDaoImpl;
import dto.hq.hr.EmployeeDTO;
import dto.hq.hr.HqScheduleDTO;

public class HqScheduleServiceImpl implements HqScheduleService {
	private HqScheduleDao scheduleDao;
	private EmployeeDao employeeDao;

	public HqScheduleServiceImpl() {
		scheduleDao = new HqScheduleDaoImpl();
		employeeDao = new EmployeeDaoImpl();
	}

	@Override
	public void addSchedule(HqScheduleDTO schedule) throws Exception {
		// 1. 직원 존재 확인
		EmployeeDTO employee = employeeDao.selectEmployee(schedule.getEmpNo());

		if (employee == null) {
			throw new Exception("존재하지 않는 직원입니다.");
		}

		// 2. 일정 중복 확인
		Integer duplicateCnt = scheduleDao.duplicateScdCnt(schedule);

		if (duplicateCnt > 0) {
			throw new Exception("이미 등록된 일정과 겹칩니다.");
		}

		// 3. 일정 등록
		scheduleDao.insertSchedule(schedule);
	}

	@Override
	public HqScheduleDTO selectSchedule(Integer scheduleId) throws Exception {
		return scheduleDao.selectSchedule(scheduleId);
	}

	@Override
	public List<HqScheduleDTO> searchScheduleList(HqScheduleDTO schedule) throws Exception {
		List<HqScheduleDTO> scd = scheduleDao.selectScheduleList(schedule);
		return scd;
	}

	@Override
	public void modifySchedule(HqScheduleDTO schedule) throws Exception {
		HqScheduleDTO originSchedule = scheduleDao.selectSchedule(schedule.getScheduleId());
		schedule.setEmpNo(originSchedule.getEmpNo());
	    schedule.setBranchCode(originSchedule.getBranchCode());
		
		Integer duplicateCnt = scheduleDao.duplicateScdCntForUpdate(schedule);
		if(duplicateCnt > 0) {
			throw new Exception("이미 등록된 일정과 겹칩니다.");
		}
		scheduleDao.updateSchedule(schedule);
	}

	@Override
	public List<EmployeeDTO> selectHqEmployee() throws Exception {
		return scheduleDao.selectHqEmployee();
	}

	@Override
	public void removeSchedule(Integer scheduleId) throws Exception {
		scheduleDao.deleteSchedule(scheduleId);
	}
}
