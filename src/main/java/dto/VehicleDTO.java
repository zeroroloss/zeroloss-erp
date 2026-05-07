package dto;

public class VehicleDTO {
	private Integer vehicleId;
	private String regionCode;
	private String plateNumber;
	private Integer capacity;
	private Boolean isActive;

	public VehicleDTO() {}

	public VehicleDTO(Integer vehicleId, String regionCode, String plateNumber, Integer capacity, Boolean isActive) {
		super();
		this.vehicleId = vehicleId;
		this.regionCode = regionCode;
		this.plateNumber = plateNumber;
		this.capacity = capacity;
		this.isActive = isActive;
	}

	public Integer getVehicleId() {
		return vehicleId;
	}

	public void setVehicleId(Integer vehicleId) {
		this.vehicleId = vehicleId;
	}

	public String getRegionCode() {
		return regionCode;
	}

	public void setRegionCode(String regionCode) {
		this.regionCode = regionCode;
	}

	public String getPlateNumber() {
		return plateNumber;
	}

	public void setPlateNumber(String plateNumber) {
		this.plateNumber = plateNumber;
	}

	public Integer getCapacity() {
		return capacity;
	}

	public void setCapacity(Integer capacity) {
		this.capacity = capacity;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	@Override
	public String toString() {
		return "VehicleDTO [vehicleId=" + vehicleId + ", regionCode=" + regionCode + ", plateNumber=" + plateNumber + ", capacity=" + capacity + ", isActive=" + isActive + "]";
	}
}

