package dto.hq.place_order;

public class PlaceOrderMaterialDTO {
	private String materialCode;	// 품목 코드
	private String materialName;	// 품목명
	private String categoryName;	// 카테고리
	
	private int currentQtySum;		// 현재 재고 합
	private int safetyQty;			// 안전 재고
	private int requestQty;			// 요청 수량
	
	private String unit;			// 단위
	
	private Integer minQty;			// 품목의 최소 발주 수량
	private Integer maxQty;			// 품목의 최대 발주 수량
	
	
	public PlaceOrderMaterialDTO() {}
	
	public PlaceOrderMaterialDTO(String materialCode, String materialName, String categoryName, int currentQtySum,
			int safetyQty, int requestQty, String unit, Integer minQty, Integer maxQty) {
		super();
		this.materialCode = materialCode;
		this.materialName = materialName;
		this.categoryName = categoryName;
		this.currentQtySum = currentQtySum;
		this.safetyQty = safetyQty;
		this.requestQty = requestQty;
		this.unit = unit;
		this.minQty = minQty;
		this.maxQty = maxQty;
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
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public int getCurrentQtySum() {
		return currentQtySum;
	}
	public void setCurrentQtySum(int currentQtySum) {
		this.currentQtySum = currentQtySum;
	}
	public int getSafetyQty() {
		return safetyQty;
	}
	public void setSafetyQty(int safetyQty) {
		this.safetyQty = safetyQty;
	}
	public int getRequestQty() {
		return requestQty;
	}
	public void setRequestQty(int requestQty) {
		this.requestQty = requestQty;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
	public Integer getMinQty() {
		return minQty;
	}
	public void setMinQty(Integer minQty) {
		this.minQty = minQty;
	}
	public Integer getMaxQty() {
		return maxQty;
	}
	public void setMaxQty(Integer maxQty) {
		this.maxQty = maxQty;
	}

	@Override
	public String toString() {
		return "PlaceOrderMaterialDTO [materialCode=" + materialCode + ", materialName=" + materialName
				+ ", categoryName=" + categoryName + ", currentQty=" + currentQtySum + ", safetyQty=" + safetyQty
				+ ", requestQty=" + requestQty + ", unit=" + unit + ", minQty=" + minQty + ", maxQty=" + maxQty + "]";
	}


}
