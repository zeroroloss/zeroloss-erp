package dto.hq.hr;

import java.time.LocalDate;
import java.time.LocalTime;

public class ScheduleDTO {
	private Integer scheduleId;
	private Integer empNo;
	private Integer branchCode;
	private LocalDate workDate;
	private LocalTime startTime;
	private LocalTime endTime;
	private Integer isRepeat;
	private String memo;
	private String workType;

	public ScheduleDTO() {
		super();
	}

	public ScheduleDTO(Integer scheduleId, Integer empNo, Integer branchCode, LocalDate workDate, LocalTime startTime, LocalTime endTime, Integer isRepeat, String memo, String workType) {
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

	public LocalDate getWorkDate() {
		return workDate;
	}

	public void setWorkDate(LocalDate workDate) {
		this.workDate = workDate;
	}

	public LocalTime getStartTime() {
		return startTime;
	}

	public void setStartTime(LocalTime startTime) {
		this.startTime = startTime;
	}

	public LocalTime getEndTime() {
		return endTime;
	}

	public void setEndTime(LocalTime endTime) {
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

	@Override
	public String toString() {
		return "ScheduleDTO [scheduleId=" + scheduleId + ", empNo=" + empNo + ", branchCode=" + branchCode + ", workDate=" + workDate + ", startTime=" + startTime + ", endTime=" + endTime + ", isRepeat=" + isRepeat + ", memo=" + memo + ", workType=" + workType + "]";
	}
}

