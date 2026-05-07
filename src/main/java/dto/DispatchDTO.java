package dto;

public class DispatchDTO {
	private Integer deliveryId;
	private String poNo;
	private Integer driverId;
	private Integer vehicleId;
	private String status;

	public DispatchDTO() {}

	public DispatchDTO(Integer deliveryId, String poNo, Integer driverId, Integer vehicleId, String status) {
		super();
		this.deliveryId = deliveryId;
		this.poNo = poNo;
		this.driverId = driverId;
		this.vehicleId = vehicleId;
		this.status = status;
	}

	public Integer getDeliveryId() {
		return deliveryId;
	}

	public void setDeliveryId(Integer deliveryId) {
		this.deliveryId = deliveryId;
	}

	public String getPoNo() {
		return poNo;
	}

	public void setPoNo(String poNo) {
		this.poNo = poNo;
	}

	public Integer getDriverId() {
		return driverId;
	}

	public void setDriverId(Integer driverId) {
		this.driverId = driverId;
	}

	public Integer getVehicleId() {
		return vehicleId;
	}

	public void setVehicleId(Integer vehicleId) {
		this.vehicleId = vehicleId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "DispatchDTO [deliveryId=" + deliveryId + ", poNo=" + poNo + ", driverId=" + driverId + ", vehicleId=" + vehicleId + ", status=" + status + "]";
	}
}

