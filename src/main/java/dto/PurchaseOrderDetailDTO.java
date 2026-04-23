package dto;

import java.math.BigDecimal;

public class PurchaseOrderDetailDTO {
	private Integer poDetailId;
	private Integer poId;
	private String materialCode;
	private BigDecimal requestedQty;
	private BigDecimal approvedQty;

	public PurchaseOrderDetailDTO() {
		super();
	}

	public PurchaseOrderDetailDTO(Integer poDetailId, Integer poId, String materialCode, BigDecimal requestedQty, BigDecimal approvedQty) {
		super();
		this.poDetailId = poDetailId;
		this.poId = poId;
		this.materialCode = materialCode;
		this.requestedQty = requestedQty;
		this.approvedQty = approvedQty;
	}

	public Integer getPoDetailId() {
		return poDetailId;
	}

	public void setPoDetailId(Integer poDetailId) {
		this.poDetailId = poDetailId;
	}

	public Integer getPoId() {
		return poId;
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

	@Override
	public String toString() {
		return "PurchaseOrderDetailDTO [poDetailId=" + poDetailId + ", poId=" + poId + ", materialCode=" + materialCode + ", requestedQty=" + requestedQty + ", approvedQty=" + approvedQty + "]";
	}
}

