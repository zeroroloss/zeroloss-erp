package dto.branch.place_order;

import java.util.List;

public class PlaceOrderHistoryDTO {

    private Integer poId;
    private String poNo;
    private Integer branchCode;
    private String branchName;
    private String createdAt;
    private Integer itemCount;
    private Integer totalQty;
    private Integer totalMaterialCnt;
    private Integer totalAmount;
    private String status;
    private String rejectReason;
    private String detailUrl;
    private String cancelUrl;
    // 발주 품목 상세
    private List<PlaceOrderDetailDTO> details;
    
    

    @Override
	public String toString() {
		return "PlaceOrderHistoryDTO [poId=" + poId + ", poNo=" + poNo + ", branchCode=" + branchCode + ", branchName="
				+ branchName + ", createdAt=" + createdAt + ", itemCount=" + itemCount + ", totalQty=" + totalQty
				+ ", totalMaterialCnt=" + totalMaterialCnt + ", totalAmount=" + totalAmount + ", status=" + status
				+ ", rejectReason=" + rejectReason + ", detailUrl=" + detailUrl + ", cancelUrl=" + cancelUrl
				+ ", details=" + details + "]\n";
	}

	public Integer getPoId() {
        return poId;
    }

    public void setPoId(Integer poId) {
        this.poId = poId;
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

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getItemCount() {
        return itemCount;
    }

    public void setItemCount(Integer itemCount) {
        this.itemCount = itemCount;
    }

    public Integer getTotalQty() {
        return totalQty;
    }

    public void setTotalQty(Integer totalQty) {
        this.totalQty = totalQty;
    }

    public Integer getTotalMaterialCnt() {
        return totalMaterialCnt;
    }

    public void setTotalMaterialCnt(Integer totalMaterialCnt) {
        this.totalMaterialCnt = totalMaterialCnt;
    }

    public Integer getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Integer totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }

    public String getDetailUrl() {
        return detailUrl;
    }

    public void setDetailUrl(String detailUrl) {
        this.detailUrl = detailUrl;
    }

    public String getCancelUrl() {
        return cancelUrl;
    }

    public void setCancelUrl(String cancelUrl) {
        this.cancelUrl = cancelUrl;
    }

    public List<PlaceOrderDetailDTO> getDetails() {
        return details;
    }

    public void setDetails(List<PlaceOrderDetailDTO> details) {
        this.details = details;
    }

    public boolean hasDetails() {
        return details != null && !details.isEmpty();
    }
}