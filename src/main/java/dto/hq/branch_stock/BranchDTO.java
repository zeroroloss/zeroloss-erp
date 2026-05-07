package dto.hq.branch_stock;

import java.time.LocalDateTime;

public class BranchDTO {
	private Integer branchCode;
	private String regionCode;
	private String branchName;
	private String address;
	private String phone;
	private String status;
	private LocalDateTime createdAt;

	public BranchDTO() { }

	public BranchDTO(Integer branchCode, String regionCode, String branchName, String address, String phone, String status, LocalDateTime createdAt) {
		super();
		this.branchCode = branchCode;
		this.regionCode = regionCode;
		this.branchName = branchName;
		this.address = address;
		this.phone = phone;
		this.status = status;
		this.createdAt = createdAt;
	}

	public Integer getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(Integer branchCode) {
		this.branchCode = branchCode;
	}

	public String getRegionCode() {
		return regionCode;
	}

	public void setRegionCode(String regionCode) {
		this.regionCode = regionCode;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
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

	@Override
	public String toString() {
		return "BranchDTO [branchCode=" + branchCode + ", regionCode=" + regionCode + ", branchName=" + branchName + ", address=" + address + ", phone=" + phone + ", status=" + status + ", createdAt=" + createdAt + "]";
	}
}

