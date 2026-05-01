package dto.hq.place_order;

import java.util.ArrayList;
import java.util.List;

public class PlaceOrderProcessingDTO {

    private Integer poId;
    private String poNo;
    private Integer branchCode;
    private String branchName;
    private String requestDate;
    private String status;
    private String rejectReason;
    private Integer totalMaterialCnt;
    private Integer totalAmount;
    private Integer totalRequestedQty;
    private List<PlaceOrderProcessingDetailDTO> details = new ArrayList<>();

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

    public String getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(String requestDate) {
        this.requestDate = requestDate;
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

    public Integer getTotalRequestedQty() {
        return totalRequestedQty;
    }

    public void setTotalRequestedQty(Integer totalRequestedQty) {
        this.totalRequestedQty = totalRequestedQty;
    }

    public List<PlaceOrderProcessingDetailDTO> getDetails() {
        return details;
    }

    public void setDetails(List<PlaceOrderProcessingDetailDTO> details) {
        this.details = details;
    }
}
