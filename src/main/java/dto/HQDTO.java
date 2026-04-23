package dto;

public class HQDTO {
	private Integer hqId;
	private Integer branchCode;
	private String address;
	private String phone;
	private String regionCode;

	public HQDTO() {
		super();
	}

	public HQDTO(Integer hqId, Integer branchCode, String address, String phone, String regionCode) {
		super();
		this.hqId = hqId;
		this.branchCode = branchCode;
		this.address = address;
		this.phone = phone;
		this.regionCode = regionCode;
	}

	public Integer getHqId() {
		return hqId;
	}

	public void setHqId(Integer hqId) {
		this.hqId = hqId;
	}

	public Integer getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(Integer branchCode) {
		this.branchCode = branchCode;
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

	public String getRegionCode() {
		return regionCode;
	}

	public void setRegionCode(String regionCode) {
		this.regionCode = regionCode;
	}

	@Override
	public String toString() {
		return "HQDTO [hqId=" + hqId + ", branchCode=" + branchCode + ", address=" + address + ", phone=" + phone + ", regionCode=" + regionCode + "]";
	}
}

