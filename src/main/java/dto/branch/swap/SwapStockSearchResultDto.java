package dto.branch.swap;

import java.math.BigDecimal;

public class SwapStockSearchResultDto {
    private int branchCode;
    private String branchName;
    private String address;
    private BigDecimal currentQty;
    private double distance;
    private double lat;
    private double lng;

    public SwapStockSearchResultDto() {
    }

    public SwapStockSearchResultDto(int branchCode, String branchName, String address, BigDecimal currentQty, double distance, double lat, double lng) {
        this.branchCode = branchCode;
        this.branchName = branchName;
        this.address = address;
        this.currentQty = currentQty;
        this.distance = distance;
        this.lat = lat;
        this.lng = lng;
    }

    // Getters
    public int getBranchCode() { return branchCode; }
    public String getBranchName() { return branchName; }
    public String getAddress() { return address; }
    public BigDecimal getCurrentQty() { return currentQty; }
    public double getDistance() { return distance; }
    public double getLat() { return lat; }
    public double getLng() { return lng; }

    // Setters
    public void setBranchCode(int branchCode) { this.branchCode = branchCode; }
    public void setBranchName(String branchName) { this.branchName = branchName; }
    public void setAddress(String address) { this.address = address; }
    public void setCurrentQty(BigDecimal currentQty) { this.currentQty = currentQty; }
    public void setDistance(double distance) { this.distance = distance; }
    public void setLat(double lat) { this.lat = lat; }
    public void setLng(double lng) { this.lng = lng; }
}
