package dto.branch.place_order;

import java.io.Serializable;
import java.util.List;

public class PlaceOrderRequestDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer poId;
    private String poNo;
    private Integer branchCode;
    private String status;
    private Integer totalMaterialCnt;
    private Integer totalAmount;
    private String rejectReason;
    private List<PlaceOrderRequestDetailDTO> details;

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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }

    public List<PlaceOrderRequestDetailDTO> getDetails() {
        return details;
    }

    public void setDetails(List<PlaceOrderRequestDetailDTO> details) {
        this.details = details;
    }

    public boolean hasDetails() {
        return details != null && !details.isEmpty();
    }
}