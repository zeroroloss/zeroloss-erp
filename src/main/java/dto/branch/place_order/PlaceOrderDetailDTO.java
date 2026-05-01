package dto.branch.place_order;


// 발주 품목 상세
public class PlaceOrderDetailDTO {

    private Integer poDetailId;
    private Integer poId;
    private String materialCode;
    private String materialName;
    private Integer requestedQty;
    private Integer approvedQty;
    private Integer remainingQty;
    private String unit;

    public Integer getRequestedQty() {
		return requestedQty;
	}

	public void setRequestedQty(Integer requestedQty) {
		this.requestedQty = requestedQty;
	}

	public Integer getApprovedQty() {
		return approvedQty;
	}

	public void setApprovedQty(Integer approvedQty) {
		this.approvedQty = approvedQty;
	}

	public Integer getRemainingQty() {
		return remainingQty;
	}

	public void setRemainingQty(Integer remainingQty) {
		this.remainingQty = remainingQty;
	}

	public Integer getPoDetailId() {
        return poDetailId;
    }

    public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public void setPoDetailId(Integer poDetailId) {
        this.poDetailId = poDetailId;
    }

    public Integer getPoId() {
        return poId;
    }

    public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}

	public void setPoId(Integer poId) {
        this.poId = poId;
    }

    public String getMaterialCode() {
        return materialCode;
    }

    public void setMaterialCode(String materialCode) {
        this.materialCode = materialCode;
    }

    
}