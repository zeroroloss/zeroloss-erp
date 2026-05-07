package dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class HqInboundDTO {
	private Integer hqInboundId;
	private String supplierName;
	private LocalDateTime receivedAt;
	private String materialCode;
	private BigDecimal qty;
	private LocalDate expiryDate;

	public HqInboundDTO() {}

	public HqInboundDTO(Integer hqInboundId, String supplierName, LocalDateTime receivedAt, String materialCode, BigDecimal qty, LocalDate expiryDate) {
		super();
		this.hqInboundId = hqInboundId;
		this.supplierName = supplierName;
		this.receivedAt = receivedAt;
		this.materialCode = materialCode;
		this.qty = qty;
		this.expiryDate = expiryDate;
	}

	public Integer getHqInboundId() {
		return hqInboundId;
	}

	public void setHqInboundId(Integer hqInboundId) {
		this.hqInboundId = hqInboundId;
	}

	public String getSupplierName() {
		return supplierName;
	}

	public void setSupplierName(String supplierName) {
		this.supplierName = supplierName;
	}

	public LocalDateTime getReceivedAt() {
		return receivedAt;
	}

	public void setReceivedAt(LocalDateTime receivedAt) {
		this.receivedAt = receivedAt;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	public BigDecimal getQty() {
		return qty;
	}

	public void setQty(BigDecimal qty) {
		this.qty = qty;
	}

	public LocalDate getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(LocalDate expiryDate) {
		this.expiryDate = expiryDate;
	}

	@Override
	public String toString() {
		return "HqInboundDTO [hqInboundId=" + hqInboundId + ", supplierName=" + supplierName + ", receivedAt=" + receivedAt + ", materialCode=" + materialCode + ", qty=" + qty + ", expiryDate=" + expiryDate + "]";
	}
}

