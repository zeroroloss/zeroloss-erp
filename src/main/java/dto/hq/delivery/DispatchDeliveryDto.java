package dto.hq.delivery;

import java.util.Date;

public class DispatchDeliveryDto {
    private int deliveryId;
    private String poNo;
    private String branchName;
    private String driverName;
    private String vehiclePlate;
    private String dispatchStatus;
    private String placeOrderStatus;
    private Date requestDate;

    public int getDeliveryId() { return deliveryId; }
    public void setDeliveryId(int deliveryId) { this.deliveryId = deliveryId; }

    public String getPoNo() { return poNo; }
    public void setPoNo(String poNo) { this.poNo = poNo; }

    public String getBranchName() { return branchName; }
    public void setBranchName(String branchName) { this.branchName = branchName; }

    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }

    public String getVehiclePlate() { return vehiclePlate; }
    public void setVehiclePlate(String vehiclePlate) { this.vehiclePlate = vehiclePlate; }

    public String getDispatchStatus() { return dispatchStatus; }
    public void setDispatchStatus(String dispatchStatus) { this.dispatchStatus = dispatchStatus; }

    public String getPlaceOrderStatus() { return placeOrderStatus; }
    public void setPlaceOrderStatus(String placeOrderStatus) { this.placeOrderStatus = placeOrderStatus; }

    public Date getRequestDate() { return requestDate; }
    public void setRequestDate(Date requestDate) { this.requestDate = requestDate; }
}

