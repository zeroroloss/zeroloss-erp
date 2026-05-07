package dto;

public class DriverDTO {
	private Integer driverId;
	private String regionCode;
	private String name;
	private String phone;
	private Boolean isActive;

	public DriverDTO() {}

	public DriverDTO(Integer driverId, String regionCode, String name, String phone, Boolean isActive) {
		super();
		this.driverId = driverId;
		this.regionCode = regionCode;
		this.name = name;
		this.phone = phone;
		this.isActive = isActive;
	}

	public Integer getDriverId() {
		return driverId;
	}

	public void setDriverId(Integer driverId) {
		this.driverId = driverId;
	}

	public String getRegionCode() {
		return regionCode;
	}

	public void setRegionCode(String regionCode) {
		this.regionCode = regionCode;
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

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	@Override
	public String toString() {
		return "DriverDTO [driverId=" + driverId + ", regionCode=" + regionCode + ", name=" + name + ", phone=" + phone + ", isActive=" + isActive + "]";
	}
}

