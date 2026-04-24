package dto.hq.warehouse;

import java.util.List;

// 특정 재고의 상세 정보 (변동 이력 포함)
public class WarehouseStockDetailDTO {
    private String stockNo;
    private String category;
    private String materialCode;
    private String materialName;
    private Integer currentQty;
    private String unit;
    private String receivedAt; // 문자열로 받기
    private String expiryDate; // 문자열로 받기
    private String status;
    // 변동이력
    private List<WarehouseStockMovementDTO> movements;

	public String getStockNo() {
		return stockNo;
	}

	public void setStockNo(String stockNo) {
		this.stockNo = stockNo;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}

	public Integer getCurrentQty() {
		return currentQty;
	}

	public void setCurrentQty(Integer currentQty) {
		this.currentQty = currentQty;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getReceivedAt() {
		return receivedAt;
	}

	public void setReceivedAt(String receivedAt) {
		this.receivedAt = receivedAt;
	}

	public String getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public List<WarehouseStockMovementDTO> getMovements() {
		return movements;
	}

	public void setMovements(List<WarehouseStockMovementDTO> movements) {
		this.movements = movements;
	}
    
    
}
