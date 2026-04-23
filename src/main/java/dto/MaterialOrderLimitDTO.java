package dto;

import java.math.BigDecimal;

public class MaterialOrderLimitDTO {
	private Integer moLimitId;
	private String materialCode;
	private BigDecimal minQty;
	private BigDecimal maxQty;

	public MaterialOrderLimitDTO() {
		super();
	}

	public MaterialOrderLimitDTO(Integer moLimitId, String materialCode, BigDecimal minQty, BigDecimal maxQty) {
		super();
		this.moLimitId = moLimitId;
		this.materialCode = materialCode;
		this.minQty = minQty;
		this.maxQty = maxQty;
	}

	public Integer getMoLimitId() {
		return moLimitId;
	}

	public void setMoLimitId(Integer moLimitId) {
		this.moLimitId = moLimitId;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	public BigDecimal getMinQty() {
		return minQty;
	}

	public void setMinQty(BigDecimal minQty) {
		this.minQty = minQty;
	}

	public BigDecimal getMaxQty() {
		return maxQty;
	}

	public void setMaxQty(BigDecimal maxQty) {
		this.maxQty = maxQty;
	}

	@Override
	public String toString() {
		return "MaterialOrderLimitDTO [moLimitId=" + moLimitId + ", materialCode=" + materialCode + ", minQty=" + minQty + ", maxQty=" + maxQty + "]";
	}
}

