package dto.hq.place_order;

public class PlaceOrderOverviewMaterialDTO {
	private String materialName;
	private Double requestedQty;
	private Double currentStock;
	private Double safetyStock;
	private String unit;
	
	@Override
	public String toString() {
		return "PlaceOrderOverviewMaterialDTO [materialName=" + materialName + ", requestedQty=" + requestedQty
				+ ", currentStock=" + currentStock + ", safetyStock=" + safetyStock + ", unit=" + unit + "]";
	}
	
	public String getMaterialName() {
		return materialName;
	}
	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}
	public Double getRequestedQty() {
		return requestedQty;
	}
	public void setRequestedQty(Double requestedQty) {
		this.requestedQty = requestedQty;
	}
	public Double getCurrentStock() {
		return currentStock;
	}
	public void setCurrentStock(Double currentStock) {
		this.currentStock = currentStock;
	}
	public Double getSafetyStock() {
		return safetyStock;
	}
	public void setSafetyStock(Double safetyStock) {
		this.safetyStock = safetyStock;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
	
	
}
