package dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class BranchStockDTO {
	private String branchStockCode;
	private Integer branchCode;
	private String materialCode;
	private LocalDate expireDate;
	private LocalDateTime receivedAt;
	private BigDecimal currentQty;

	public BranchStockDTO() {
		super();
	}

	public BranchStockDTO(String branchStockCode, Integer branchCode, String materialCode, LocalDate expireDate, LocalDateTime receivedAt, BigDecimal currentQty) {
		super();
		this.branchStockCode = branchStockCode;
		this.branchCode = branchCode;
		this.materialCode = materialCode;
		this.expireDate = expireDate;
		this.receivedAt = receivedAt;
		this.currentQty = currentQty;
	}

	public String getBranchStockCode() {
		return branchStockCode;
	}

	public void setBranchStockCode(String branchStockCode) {
		this.branchStockCode = branchStockCode;
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

	public LocalDate getExpireDate() {
		return expireDate;
	}

	public void setExpireDate(LocalDate expireDate) {
		this.expireDate = expireDate;
	}

	public LocalDateTime getReceivedAt() {
		return receivedAt;
	}

	public void setReceivedAt(LocalDateTime receivedAt) {
		this.receivedAt = receivedAt;
	}

	public BigDecimal getCurrentQty() {
		return currentQty;
	}

	public void setCurrentQty(BigDecimal currentQty) {
		this.currentQty = currentQty;
	}

	@Override
	public String toString() {
		return "BranchStockDTO [branchStockCode=" + branchStockCode + ", branchCode=" + branchCode + ", materialCode=" + materialCode + ", expireDate=" + expireDate + ", receivedAt=" + receivedAt + ", currentQty=" + currentQty + "]";
	}
}

