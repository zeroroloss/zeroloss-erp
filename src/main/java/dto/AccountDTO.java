package dto;

import java.time.LocalDateTime;

public class AccountDTO {
	private Integer accountId;
	private Integer empNo;
	private Integer branchCode;
	private Integer hqId;
	private Integer roleId;
	private String loginId;
	private String password;
	private String status;
	private LocalDateTime createdAt;
	private LocalDateTime lastLoginAt;
	private String userName;
	private String roleName;
	private String branchName;
	
	public AccountDTO() {
		super();
	}

	public AccountDTO(Integer accountId, Integer empNo, Integer branchCode, Integer hqId, Integer roleId, String loginId,
			String password, String status, LocalDateTime lastLoginAt) {
		super();
		this.accountId = accountId;
		this.empNo = empNo;
		this.branchCode = branchCode;
		this.hqId = hqId;
		this.roleId = roleId;
		this.loginId = loginId;
		this.password = password;
		this.status = status;
		this.lastLoginAt = lastLoginAt;
	}

	public AccountDTO(Integer accountId, Integer empNo, Integer branchCode, Integer roleId, String loginId,
			String password, String status, LocalDateTime lastLoginAt) {
		super();
		this.accountId = accountId;
		this.empNo = empNo;
		this.branchCode = branchCode;
		this.roleId = roleId;
		this.loginId = loginId;
		this.password = password;
		this.status = status;
		this.lastLoginAt = lastLoginAt;
	}

	public AccountDTO(Integer accountId, Integer empNo, Integer branchCode, Integer roleId, String loginId,
			String password, String status) {
		super();
		this.accountId = accountId;
		this.empNo = empNo;
		this.branchCode = branchCode;
		this.roleId = roleId;
		this.loginId = loginId;
		this.password = password;
		this.status = status;
	}

	public Integer getAccountId() {
		return accountId;
	}

	public void setAccountId(Integer accountId) {
		this.accountId = accountId;
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

	public Integer getHqId() {
		return hqId;
	}

	public void setHqId(Integer hqId) {
		this.hqId = hqId;
	}

	public Integer getRoleId() {
		return roleId;
	}

	public void setRoleId(Integer roleId) {
		this.roleId = roleId;
	}

	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public LocalDateTime getLastLoginAt() {
		return lastLoginAt;
	}

	public void setLastLoginAt(LocalDateTime lastLoginAt) {
		this.lastLoginAt = lastLoginAt;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getRoleName() {
		return roleName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	@Override
	public String toString() {
		return "AccountDTO [accountId=" + accountId + ", empNo=" + empNo + ", branchCode=" + branchCode + ", hqId="
				+ hqId + ", roleId=" + roleId + ", loginId=" + loginId + ", password=" + password + ", status=" + status
				+ ", createdAt=" + createdAt + ", lastLoginAt=" + lastLoginAt + ", userName=" + userName + ", roleName="
				+ roleName + ", branchName=" + branchName + "]";
	}

}