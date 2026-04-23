package dto;

import java.time.LocalDateTime;

public class BranchStockReceiptDTO {
	private Integer receiptId;
	private String branchStockCode;
	private Integer purchaseOrderId;
	private LocalDateTime receivedAt;
	private Integer receivedCnt;
	private Integer branchCode;
	private String materialCode;

	public BranchStockReceiptDTO() {
		super();
	}

	public BranchStockReceiptDTO(Integer receiptId, String branchStockCode, Integer purchaseOrderId, LocalDateTime receivedAt, Integer receivedCnt, Integer branchCode, String materialCode) {
		super();
		this.receiptId = receiptId;
		this.branchStockCode = branchStockCode;
		this.purchaseOrderId = purchaseOrderId;
		this.receivedAt = receivedAt;
		this.receivedCnt = receivedCnt;
		this.branchCode = branchCode;
		this.materialCode = materialCode;
	}

	public Integer getReceiptId() {
		return receiptId;
	}

	public void setReceiptId(Integer receiptId) {
		this.receiptId = receiptId;
	}

	public String getBranchStockCode() {
		return branchStockCode;
	}

	public void setBranchStockCode(String branchStockCode) {
		this.branchStockCode = branchStockCode;
	}

	public Integer getPurchaseOrderId() {
		return purchaseOrderId;
	}

	public void setPurchaseOrderId(Integer purchaseOrderId) {
		this.purchaseOrderId = purchaseOrderId;
	}

	public LocalDateTime getReceivedAt() {
		return receivedAt;
	}

	public void setReceivedAt(LocalDateTime receivedAt) {
		this.receivedAt = receivedAt;
	}

	public Integer getReceivedCnt() {
		return receivedCnt;
	}

	public void setReceivedCnt(Integer receivedCnt) {
		this.receivedCnt = receivedCnt;
	}

	public Integer getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(Integer branchCode) {
		this.branchCode = branchCode;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	@Override
	public String toString() {
		return "BranchStockReceiptDTO [receiptId=" + receiptId + ", branchStockCode=" + branchStockCode + ", purchaseOrderId=" + purchaseOrderId + ", receivedAt=" + receivedAt + ", receivedCnt=" + receivedCnt + ", branchCode=" + branchCode + ", materialCode=" + materialCode + "]";
	}
}

