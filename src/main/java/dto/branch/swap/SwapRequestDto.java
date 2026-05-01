package dto.branch.swap;

public class SwapRequestDto {
    private int swapId;
    private int reqBranchCode;
    private String reqBranchName;
    private int resBranchCode;
    private String resBranchName;
    private String materialCode;
    private String materialName;
    private double qty;
    private String status;
    private String reqDate;
    private String address;
    private double distance;

    public SwapRequestDto() {}

    public SwapRequestDto(int swapId, int reqBranchCode, String reqBranchName, int resBranchCode,
                          String resBranchName, String materialCode, String materialName,
                          double qty, String status, String reqDate, String address, double distance) {
        this.swapId = swapId;
        this.reqBranchCode = reqBranchCode;
        this.reqBranchName = reqBranchName;
        this.resBranchCode = resBranchCode;
        this.resBranchName = resBranchName;
        this.materialCode = materialCode;
        this.materialName = materialName;
        this.qty = qty;
        this.status = status;
        this.reqDate = reqDate;
        this.address = address;
        this.distance = distance;
    }

    // Getters and Setters
    public int getSwapId() { return swapId; }
    public void setSwapId(int swapId) { this.swapId = swapId; }

    public int getReqBranchCode() { return reqBranchCode; }
    public void setReqBranchCode(int reqBranchCode) { this.reqBranchCode = reqBranchCode; }

    public String getReqBranchName() { return reqBranchName; }
    public void setReqBranchName(String reqBranchName) { this.reqBranchName = reqBranchName; }

    public int getResBranchCode() { return resBranchCode; }
    public void setResBranchCode(int resBranchCode) { this.resBranchCode = resBranchCode; }

    public String getResBranchName() { return resBranchName; }
    public void setResBranchName(String resBranchName) { this.resBranchName = resBranchName; }

    public String getMaterialCode() { return materialCode; }
    public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }

    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }

    public double getQty() { return qty; }
    public void setQty(double qty) { this.qty = qty; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getReqDate() { return reqDate; }
    public void setReqDate(String reqDate) { this.reqDate = reqDate; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public double getDistance() { return distance; }
    public void setDistance(double distance) { this.distance = distance; }
}

