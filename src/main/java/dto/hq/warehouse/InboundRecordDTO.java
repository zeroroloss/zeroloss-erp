package dto.hq.warehouse;

public class InboundRecordDTO {
    private String inboundNo;     // 입고번호
    private String supplierName;  // 공급사명
    private String categoryName;      // 카테고리
    private String itemName;  	  // 품목명
    private String unit;          // 단위
    private int    quantity;      // 수량
    private int    unitPrice;     // 단가
    private int    totalPrice;    // 합계
    private String expiryDate;    // 유통기한
    private String receivedAt;     // 입고일시
	public String getInboundNo() {
		return inboundNo;
	}
	public void setInboundNo(String inboundNo) {
		this.inboundNo = inboundNo;
	}
	public String getSupplierName() {
		return supplierName;
	}
	public void setSupplierName(String supplierName) {
		this.supplierName = supplierName;
	}
	public String getCategory() {
		return categoryName;
	}
	public void setCategory(String category) {
		this.categoryName = category;
	}
	public String getMaterialName() {
		return itemName;
	}
	public void setMaterialName(String materialName) {
		this.itemName = materialName;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
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
	public int getTotalPrice() {
		return totalPrice;
	}
	public void setTotalPrice(int totalPrice) {
		this.totalPrice = totalPrice;
	}
	public String getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}
	public String getInboundAt() {
		return receivedAt;
	}
	public void setInboundAt(String inboundAt) {
		this.receivedAt = inboundAt;
	}

    
}
