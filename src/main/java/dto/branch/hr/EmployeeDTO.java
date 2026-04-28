package dto.branch.hr;

import java.sql.Date;
import java.time.LocalDate;

public class EmployeeDTO {
	private Integer empNo;
	private Integer branchCode;
	private String dept;
	private String gradeCode;
	private String positionCode;
	private String name;
	private String phone;
	private String email;
	private Date hireDate;
	private String status;
	private String branchName;
	private String positionName;
	private String gradeName;

	public EmployeeDTO() {
		super();
	}

	public EmployeeDTO(Integer empNo, Integer branchCode, String dept, String gradeCode, String positionCode,
			String name, String phone, String email, Date hireDate, String status) {
		super();
		this.empNo = empNo;
		this.branchCode = branchCode;
		this.dept = dept;
		this.gradeCode = gradeCode;
		this.positionCode = positionCode;
		this.name = name;
		this.phone = phone;
		this.email = email;
		this.hireDate = hireDate;
		this.status = status;
	}

	public EmployeeDTO(Integer empNo, Integer branchCode, String dept, String gradeCode, String name, String phone,
			String email, Date hireDate, String status) {
		super();
		this.empNo = empNo;
		this.branchCode = branchCode;
		this.dept = dept;
		this.gradeCode = gradeCode;
		this.name = name;
		this.phone = phone;
		this.email = email;
		this.hireDate = hireDate;
		this.status = status;
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

	public String getDept() {
		return dept;
	}

	public void setDept(String dept) {
		this.dept = dept;
	}

	public String getGradeCode() {
		return gradeCode;
	}

	public void setGradeCode(String gradeCode) {
		this.gradeCode = gradeCode;
	}

	public String getPositionCode() {
		return positionCode;
	}

	public void setPositionCode(String positionCode) {
		this.positionCode = positionCode;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getHireDate() {
		return hireDate;
	}

	public void setHireDate(Date date) {
		this.hireDate = date;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPositionName() {
		return positionName;
	}

	public void setPositionName(String positionName) {
		this.positionName = positionName;
	}

	public String getGradeName() {
		return gradeName;
	}

	public void setGradeName(String gradeName) {
		this.gradeName = gradeName;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	@Override
	public String toString() {
		return "EmployeeDTO [empNo=" + empNo + ", branchCode=" + branchCode + ", dept=" + dept + ", gradeCode=" + gradeCode + ", positionCode=" + positionCode + ", name=" + name + ", phone=" + phone + ", email=" + email + ", hireDate=" + hireDate + ", status=" + status + "]";
	}
}


