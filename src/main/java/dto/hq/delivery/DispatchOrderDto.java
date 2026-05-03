package dto.hq.delivery;

import java.util.Date;

public class DispatchOrderDto {
    private String poNo;
    private int branchCode;
    private String branchName;
    private String regionCode;
    private String regionName;
    private Date requestDate;
    private int totalAmount;
    private int totalMaterialCnt;

    // Getters and Setters
    public String getPoNo() { return poNo; }
    public void setPoNo(String poNo) { this.poNo = poNo; }
    public int getBranchCode() { return branchCode; }
    public void setBranchCode(int branchCode) { this.branchCode = branchCode; }
    public String getBranchName() { return branchName; }
    public void setBranchName(String branchName) { this.branchName = branchName; }
    public String getRegionCode() { return regionCode; }
    public void setRegionCode(String regionCode) { this.regionCode = regionCode; }
    public String getRegionName() { return regionName; }
    public void setRegionName(String regionName) { this.regionName = regionName; }
    public Date getRequestDate() { return requestDate; }
    public void setRequestDate(Date requestDate) { this.requestDate = requestDate; }
    public int getTotalAmount() { return totalAmount; }
    public void setTotalAmount(int totalAmount) { this.totalAmount = totalAmount; }
    public int getTotalMaterialCnt() { return totalMaterialCnt; }
    public void setTotalMaterialCnt(int totalMaterialCnt) { this.totalMaterialCnt = totalMaterialCnt; }
}
