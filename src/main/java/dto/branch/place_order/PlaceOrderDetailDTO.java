package dto.branch.place_order;

import java.math.BigDecimal;

// 발주 품목 상세
public class PlaceOrderDetailDTO {

    private Integer poDetailId;
    private Integer poId;
    private String materialCode;
    private String materialName;
    private BigDecimal requestedQty;
    private BigDecimal approvedQty;
    private BigDecimal remainingQty;
    private String unit;

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

    public BigDecimal getRequestedQty() {
        return requestedQty;
    }

    public void setRequestedQty(BigDecimal requestedQty) {
        this.requestedQty = requestedQty;
    }

    public BigDecimal getApprovedQty() {
        return approvedQty;
    }

    public void setApprovedQty(BigDecimal approvedQty) {
        this.approvedQty = approvedQty;
    }

    public BigDecimal getRemainingQty() {
        return remainingQty;
    }

    public void setRemainingQty(BigDecimal remainingQty) {
        this.remainingQty = remainingQty;
    }
    
}