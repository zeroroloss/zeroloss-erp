package dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class WarehouseStockDTO {
	private String stockNo;
	private String materialCode;
	private Integer hqInboundId;
	private BigDecimal qty;
	private LocalDateTime receivedAt;
	private LocalDate expiryDate;
	private String status;
	
	// join 필드
	private String materialName;

	public WarehouseStockDTO() {}

	public WarehouseStockDTO(String stockNo, String materialCode, Integer hqInboundId, BigDecimal qty, LocalDateTime receivedAt, LocalDate expiryDate, String status) {
		super();
		this.stockNo = stockNo;
		this.materialCode = materialCode;
		this.hqInboundId = hqInboundId;
		this.qty = qty;
		this.receivedAt = receivedAt;
		this.expiryDate = expiryDate;
		this.status = status;
	}
	
	public WarehouseStockDTO(String stockNo, String materialCode, Integer hqInboundId, BigDecimal qty,
			LocalDateTime receivedAt, LocalDate expiryDate, String status, String materialName) {
		super();
		this.stockNo = stockNo;
		this.materialCode = materialCode;
		this.hqInboundId = hqInboundId;
		this.qty = qty;
		this.receivedAt = receivedAt;
		this.expiryDate = expiryDate;
		this.status = status;
		this.materialName = materialName;
	}

	public String getStockNo() {
		return stockNo;
	}

	public void setStockNo(String stockNo) {
		this.stockNo = stockNo;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	public Integer getHqInboundId() {
		return hqInboundId;
	}

	public void setHqInboundId(Integer hqInboundId) {
		this.hqInboundId = hqInboundId;
	}

	public BigDecimal getQty() {
		return qty;
	}

	public void setQty(BigDecimal qty) {
		this.qty = qty;
	}

	public LocalDateTime getReceivedAt() {
		return receivedAt;
	}

	public void setReceivedAt(LocalDateTime receivedAt) {
		this.receivedAt = receivedAt;
	}

	public LocalDate getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(LocalDate expiryDate) {
		this.expiryDate = expiryDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}
	
	@Override
	public String toString() {
		return "WarehouseStockDTO [stockNo=" + stockNo + ", materialCode=" + materialCode + ", hqInboundId="
				+ hqInboundId + ", qty=" + qty + ", receivedAt=" + receivedAt + ", expiryDate=" + expiryDate
				+ ", status=" + status + ", materialName=" + materialName + "]";
	}
}

