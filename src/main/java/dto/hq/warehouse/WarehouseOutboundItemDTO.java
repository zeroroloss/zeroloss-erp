package dto.hq.warehouse;

import java.math.BigDecimal;

public class WarehouseOutboundItemDTO {
    private String itemCode;
    private String itemName;
    private String category;

    private BigDecimal requestedQty;
    private BigDecimal confirmedQty;
    private BigDecimal warehouseStock;

    private String unit;

	@Override
	public String toString() {
		return "WarehouseOutboundItemDTO [itemCode=" + itemCode + ", itemName=" + itemName + ", category=" + category
				+ ", requestedQty=" + requestedQty + ", confirmedQty=" + confirmedQty + ", warehouseStock="
				+ warehouseStock + ", unit=" + unit + "]";
	}

	public String getItemCode() {
		return itemCode;
	}

	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public BigDecimal getRequestedQty() {
		return requestedQty;
	}

	public void setRequestedQty(BigDecimal requestedQty) {
		this.requestedQty = requestedQty;
	}

	public BigDecimal getConfirmedQty() {
		return confirmedQty;
	}

	public void setConfirmedQty(BigDecimal confirmedQty) {
		this.confirmedQty = confirmedQty;
	}

	public BigDecimal getWarehouseStock() {
		return warehouseStock;
	}

	public void setWarehouseStock(BigDecimal warehouseStock) {
		this.warehouseStock = warehouseStock;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

}
