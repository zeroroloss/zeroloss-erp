package dto.hq.warehouse;

public class WarehouseOutboundDTO {
    private Integer hqOutboundNo;
    private String poNo;
    private Integer branchCode;
    private String branchName;
    private String status;
    private String handler;
    private String outboundAt;

    public Integer getHqOutboundNo() {
        return hqOutboundNo;
    }
    public void setHqOutboundNo(Integer hqOutboundNo) {
        this.hqOutboundNo = hqOutboundNo;
    }
    public String getPoNo() {
        return poNo;
    }
    public void setPoNo(String poNo) {
        this.poNo = poNo;
    }
    public Integer getBranchCode() {
        return branchCode;
    }
    public void setBranchCode(Integer branchCode) {
        this.branchCode = branchCode;
    }
    public String getBranchName() {
        return branchName;
    }
    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public String getHandler() {
        return handler;
    }
    public void setHandler(String handler) {
        this.handler = handler;
    }
	public String getOutboundAt() {
		return outboundAt;
	}
	public void setOutboundAt(String outboundAt) {
		this.outboundAt = outboundAt;
	}

}
