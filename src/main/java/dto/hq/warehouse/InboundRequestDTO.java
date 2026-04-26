package dto.hq.warehouse;

public class InboundRequestDTO {
	private int hqInboundId;
    private String supplier;
    private String categoryName;
    private String itemName;
    private int    quantity;
    private int    unitPrice;
    private String expiryDate;
    
	public int getHqInboundId() {
		return hqInboundId;
	}
	public void setHqInboundId(int hqInboundId) {
		this.hqInboundId = hqInboundId;
	}
	public String getSupplier() {
		return supplier;
	}
	public void setSupplier(String supplier) {
		this.supplier = supplier;
	}
	public String getCategory() {
		return categoryName;
	}
	public void setCategory(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public int getUnitPrice() {
		return unitPrice;
	}
	public void setUnitPrice(int unitPrice) {
		this.unitPrice = unitPrice;
	}
	public String getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}
    
    
}
