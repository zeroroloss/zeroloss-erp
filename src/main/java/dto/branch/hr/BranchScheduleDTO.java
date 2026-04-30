package dto.branch.hr;

import java.sql.Date;
import java.sql.Time;

public class BranchScheduleDTO {
	private Integer scheduleId;
	private Integer empNo;
	private Integer branchCode;
	private Date workDate;
	private Time startTime;
	private Time endTime;
	private Integer isRepeat; 
	private String memo;
	private String workType;
	private String empName;
	private String branchName;

	public BranchScheduleDTO() {
		super();
	}

	public BranchScheduleDTO(Integer scheduleId, Integer empNo, Integer branchCode, Date workDate, Time startTime,
			Time endTime, Integer isRepeat, String memo, String workType) {
		super();
		this.scheduleId = scheduleId;
		this.empNo = empNo;
		this.branchCode = branchCode;
		this.workDate = workDate;
		this.startTime = startTime;
		this.endTime = endTime;
		this.isRepeat = isRepeat;
		this.memo = memo;
		this.workType = workType;
	}

	public Integer getScheduleId() {
		return scheduleId;
	}

	public void setScheduleId(Integer scheduleId) {
		this.scheduleId = scheduleId;
	}

	public Integer getEmpNo() {
		return empNo;
	}

	public void setEmpNo(Integer empNo) {
		this.empNo = empNo;
	}

	public Integer getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(Integer branchCode) {
		this.branchCode = branchCode;
	}

	public Date getWorkDate() {
		return workDate;
	}

	public void setWorkDate(Date workDate) {
		this.workDate = workDate;
	}

	public Time getStartTime() {
		return startTime;
	}

	public void setStartTime(Time startTime) {
		this.startTime = startTime;
	}

	public Time getEndTime() {
		return endTime;
	}

	public void setEndTime(Time endTime) {
		this.endTime = endTime;
	}

	public Integer getIsRepeat() {
		return isRepeat;
	}

	public void setIsRepeat(Integer isRepeat) {
		this.isRepeat = isRepeat;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public String getWorkType() {
		return workType;
	}

	public void setWorkType(String workType) {
		this.workType = workType;
	}

	public String getEmpName() {
		return empName;
	}

	public void setEmpName(String empName) {
		this.empName = empName;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
}
