package dto.hq.delivery;

public class DispatchCreationDto {
    private String poNo;
    private int driverId;
    private int vehicleId;

    // Getters and Setters
    public String getPoNo() { return poNo; }
    public void setPoNo(String poNo) { this.poNo = poNo; }
    public int getDriverId() { return driverId; }
    public void setDriverId(int driverId) { this.driverId = driverId; }
    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }
}
