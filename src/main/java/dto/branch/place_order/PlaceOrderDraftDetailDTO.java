package dto.branch.place_order;

public class PlaceOrderDraftDetailDTO {
    private Integer draftDetailId;

    private Integer draftId;

    private String materialCode;

    private Integer requestedQty;

    // LOW_STOCK / MANUAL
    private String sourceType;

    // 화면 표시용 (조인해서 채움)
    private String materialName;
    private String categoryName;
    private Integer currentStock;
    private Integer safeStock;
    private String unit;
    
    //
	public PlaceOrderDraftDetailDTO() {
		super();
	}
	public PlaceOrderDraftDetailDTO(Integer draftDetailId, Integer draftId, String materialCode, Integer requestedQty,
			String sourceType, String materialName, String categoryName, Integer currentStock, Integer safeStock,
			String unit) {
		super();
		this.draftDetailId = draftDetailId;
		this.draftId = draftId;
		this.materialCode = materialCode;
		this.requestedQty = requestedQty;
		this.sourceType = sourceType;
		this.materialName = materialName;
		this.categoryName = categoryName;
		this.currentStock = currentStock;
		this.safeStock = safeStock;
		this.unit = unit;
	}
    
    @Override
	public String toString() {
		return "PlaceOrderDraftDetailDTO [draftDetailId=" + draftDetailId + ", draftId=" + draftId + ", materialCode="
				+ materialCode + ", requestedQty=" + requestedQty + ", sourceType=" + sourceType + ", materialName="
				+ materialName + ", categoryName=" + categoryName + ", currentStock=" + currentStock + ", safeStock="
				+ safeStock + ", unit=" + unit + "]";
	}
	//
	public Integer getDraftDetailId() {
		return draftDetailId;
	}
	public void setDraftDetailId(Integer draftDetailId) {
		this.draftDetailId = draftDetailId;
	}
	public Integer getDraftId() {
		return draftId;
	}
	public void setDraftId(Integer draftId) {
		this.draftId = draftId;
	}
	public String getMaterialCode() {
		return materialCode;
	}
	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}
	public Integer getRequestedQty() {
		return requestedQty;
	}
	public void setRequestedQty(Integer requestedQty) {
		this.requestedQty = requestedQty;
	}
	public String getSourceType() {
		return sourceType;
	}
	public void setSourceType(String sourceType) {
		this.sourceType = sourceType;
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
	public Integer getCurrentStock() {
		return currentStock;
	}
	public void setCurrentStock(Integer currentStock) {
		this.currentStock = currentStock;
	}
	public Integer getSafeStock() {
		return safeStock;
	}
	public void setSafeStock(Integer safeStock) {
		this.safeStock = safeStock;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
}
