package dto.hq.hr;

import java.sql.Date;

public class HqScheduleDTO {
	private Integer scheduleId;
	private Integer empNo;
	private Integer branchCode;
	private Date startDay;
	private Date endDay;
	private String memo;
	private String workType;
	private String empName;
	private String dept;
	private String branchName;

	public HqScheduleDTO() {
		super();
	}

	public HqScheduleDTO(Integer scheduleId, Integer empNo, Integer branchCode, Date startDay, Date endDay, String memo,
			String workType) {
		super();
		this.scheduleId = scheduleId;
		this.empNo = empNo;
		this.branchCode = branchCode;
		this.startDay = startDay;
		this.endDay = endDay;
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

	public Date getStartDay() {
		return startDay;
	}

	public void setStartDay(Date startDay) {
		this.startDay = startDay;
	}

	public Date getEndDay() {
		return endDay;
	}

	public void setEndDay(Date endDay) {
		this.endDay = endDay;
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

	public String getDept() {
		return dept;
	}

	public void setDept(String dept) {
		this.dept = dept;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

}
