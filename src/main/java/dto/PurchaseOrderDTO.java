package dto;

import java.time.LocalDateTime;

public class PurchaseOrderDTO {
	private Integer poId;
	private String poNo;
	private Integer branchCode;
	private String status;
	private Integer totalAmount;
	private LocalDateTime requestDate;

	public PurchaseOrderDTO() {
		super();
	}

	public PurchaseOrderDTO(Integer poId, String poNo, Integer branchCode, String status, Integer totalAmount, LocalDateTime requestDate) {
		super();
		this.poId = poId;
		this.poNo = poNo;
		this.branchCode = branchCode;
		this.status = status;
		this.totalAmount = totalAmount;
		this.requestDate = requestDate;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Integer getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(Integer totalAmount) {
		this.totalAmount = totalAmount;
	}

	public LocalDateTime getRequestDate() {
		return requestDate;
	}

	public void setRequestDate(LocalDateTime requestDate) {
		this.requestDate = requestDate;
	}

	@Override
	public String toString() {
		return "PurchaseOrderDTO [poId=" + poId + ", poNo=" + poNo + ", branchCode=" + branchCode + ", status=" + status + ", totalAmount=" + totalAmount + ", requestDate=" + requestDate + "]";
	}
}

