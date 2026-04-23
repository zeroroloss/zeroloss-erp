package dto.hq.warehouse;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class WarehouseStockResultDTO {
	
    private String stockNo;
    private String categoryName;
    private String itemName;
    private BigDecimal qty;
    private LocalDateTime receivedAt;
    private String status;
    private String detailInfo;
    
	public WarehouseStockResultDTO() {
		super();
	}
	
	public WarehouseStockResultDTO(String stockNo, String categoryName, String itemName, BigDecimal qty,
			LocalDateTime receivedAt, String status, String detailInfo) {
		super();
		this.stockNo = stockNo;
		this.categoryName = categoryName;
		this.itemName = itemName;
		this.qty = qty;
		this.receivedAt = receivedAt;
		this.status = status;
		this.detailInfo = detailInfo;
	}
	
	public String getStockNo() {
		return stockNo;
	}
	public void setStockNo(String stockNo) {
		this.stockNo = stockNo;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getDetailInfo() {
		return detailInfo;
	}
	public void setDetailInfo(String detailInfo) {
		this.detailInfo = detailInfo;
	}
    
    
}
