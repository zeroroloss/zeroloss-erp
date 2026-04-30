package service.branch;

import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

import dao.branch.BranchScheduleDao;
import dao.branch.BranchScheduleDaoImpl;
import dao.branch.EmployeeDao;
import dao.branch.EmployeeDaoImpl;
import dto.branch.hr.BranchScheduleDTO;
import dto.branch.hr.EmployeeDTO;

public class BranchScheduleServiceImpl implements BranchScheduleService {
	private BranchScheduleDao scheduleDao;
	private EmployeeDao employeeDao;

	public BranchScheduleServiceImpl() {
		scheduleDao = new BranchScheduleDaoImpl();
		employeeDao = new EmployeeDaoImpl();
	}

	@Override
	public void addBranchSchedule(BranchScheduleDTO schedule) throws Exception {
		// 1. 직원 존재 확인
		EmployeeDTO employee = employeeDao.selectEmployee(schedule.getEmpNo());

		if (employee == null) {
			throw new Exception("존재하지 않는 직원입니다.");
		}
		
		if(schedule.getIsRepeat() == 1) {
			schedule.setWorkDate(schedule.getStartDate());
			
			if(scheduleDao.duplicateScdCnt(schedule)>0) {
				throw new Exception ("이미 등록된 일정과 겹칩니다.");
			}
			scheduleDao.insertSchedule(schedule);
			return;
		}
		
		String repeatGroupId = UUID.randomUUID().toString();
		schedule.setRepeatGroupId(repeatGroupId);
		
		if(schedule.getIsRepeat() == 2) {
			insertWeeklyRepeat(schedule);
			return;
		}
		
		if(schedule.getIsRepeat() == 3) {
			insertMonthlyRepeat(schedule);
			return;
		}
	}
	
	private int insertWeeklyRepeat(BranchScheduleDTO schedule) throws Exception {
	    int result = 0;

	    LocalDate start = schedule.getStartDate().toLocalDate();
	    LocalDate end = schedule.getEndDate().toLocalDate();

	    while (!start.isAfter(end)) {
	        int weekday = convertWeekday(start.getDayOfWeek());

	        if (containsWeekday(schedule.getWeekdayRepeat(), weekday)) {
	            BranchScheduleDTO copy = copySchedule(schedule);
	            copy.setWorkDate(Date.valueOf(start));

	            if (scheduleDao.duplicateScdCnt(copy) > 0) {
	                throw new Exception("이미 등록된 일정과 겹칩니다.");
	            }

	            scheduleDao.insertSchedule(copy);
	            result++;
	        }

	        start = start.plusDays(1);
	    }

	    return result;
	}
	
	private int insertMonthlyRepeat(BranchScheduleDTO schedule) throws Exception {
	    int result = 0;

	    LocalDate current = schedule.getStartDate().toLocalDate();
	    LocalDate end = schedule.getEndDate().toLocalDate();

	    while (!current.isAfter(end)) {
	        BranchScheduleDTO copy = copySchedule(schedule);
	        copy.setWorkDate(Date.valueOf(current));

	        if (scheduleDao.duplicateScdCnt(copy) > 0) {
	            throw new Exception("이미 등록된 일정과 겹칩니다.");
	        }

	        scheduleDao.insertSchedule(copy);
	        result++;

	        current = current.plusMonths(1);
	    }

	    return result;
	}
	
	private BranchScheduleDTO copySchedule(BranchScheduleDTO schedule) {
		BranchScheduleDTO copy = new BranchScheduleDTO();

		copy.setEmpNo(schedule.getEmpNo());
		copy.setBranchCode(schedule.getBranchCode());
		copy.setStartTime(schedule.getStartTime());
		copy.setEndTime(schedule.getEndTime());
		copy.setIsRepeat(schedule.getIsRepeat());
		copy.setRepeatGroupId(schedule.getRepeatGroupId());
		copy.setMemo(schedule.getMemo());
		copy.setWorkType(schedule.getWorkType());

		return copy;
	}
	
	private boolean containsWeekday(String[] weekdayArr, int weekday) {
		if (weekdayArr == null) {
			return false;
		}

		for (String w : weekdayArr) {
			if (Integer.parseInt(w) == weekday) {
				return true;
			}
		}

		return false;
	}

	private int convertWeekday(DayOfWeek dayOfWeek) {
		switch (dayOfWeek) {
			case MONDAY:
				return 1;
			case TUESDAY:
				return 2;
			case WEDNESDAY:
				return 3;
			case THURSDAY:
				return 4;
			case FRIDAY:
				return 5;
			case SATURDAY:
				return 6;
			case SUNDAY:
				return 7;
			default:
				return 0;
		}
	}

	@Override
	public List<EmployeeDTO> selectBranchEmployee() throws Exception {
		return scheduleDao.selectBranchEmployee();
	}

	@Override
	public List<BranchScheduleDTO> searchBranchScheduleList(BranchScheduleDTO schedule) throws Exception {
		return scheduleDao.selectBranchScheduleList(schedule);
	}

	@Override
	public void modifySchedule(BranchScheduleDTO schedule) throws Exception {
		BranchScheduleDTO originSchedule = scheduleDao.selectSchedule(schedule.getScheduleId());
		schedule.setEmpNo(originSchedule.getEmpNo());
		schedule.setBranchCode(originSchedule.getBranchCode());
		
		Integer duplicateCnt = scheduleDao.duplicateScdCntForUpdate(schedule);
		if(duplicateCnt > 0) {
			throw new Exception("이미 등록된 일정과 겹칩니다.");
		}
		scheduleDao.updateSchedule(schedule);
	}

	@Override
	public void removeSchedule(Integer scheduleId) throws Exception {
		scheduleDao.deleteSchedule(scheduleId);
	}

	@Override
	public void removeRepeatSchedule(Integer repeatGroupId) throws Exception {
		scheduleDao.deleteRepeatSchedule(repeatGroupId);
	}

	@Override
	public BranchScheduleDTO selectSchedule(Integer scheduleId) throws Exception {
		return scheduleDao.selectSchedule(scheduleId);
	}

}
