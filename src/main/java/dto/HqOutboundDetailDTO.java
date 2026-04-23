package dto;

import java.math.BigDecimal;

public class HqOutboundDetailDTO {
	private Integer hqOutboundDetailId;
	private Integer outboundNo;
	private String materialCode;
	private BigDecimal qty;

	public HqOutboundDetailDTO() {
		super();
	}

	public HqOutboundDetailDTO(Integer hqOutboundDetailId, Integer outboundNo, String materialCode, BigDecimal qty) {
		super();
		this.hqOutboundDetailId = hqOutboundDetailId;
		this.outboundNo = outboundNo;
		this.materialCode = materialCode;
		this.qty = qty;
	}

	public Integer getHqOutboundDetailId() {
		return hqOutboundDetailId;
	}

	public void setHqOutboundDetailId(Integer hqOutboundDetailId) {
		this.hqOutboundDetailId = hqOutboundDetailId;
	}

	public Integer getOutboundNo() {
		return outboundNo;
	}

	public void setOutboundNo(Integer outboundNo) {
		this.outboundNo = outboundNo;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	public BigDecimal getQty() {
		return qty;
	}

	public void setQty(BigDecimal qty) {
		this.qty = qty;
	}

	@Override
	public String toString() {
		return "HqOutboundDetailDTO [hqOutboundDetailId=" + hqOutboundDetailId + ", outboundNo=" + outboundNo + ", materialCode=" + materialCode + ", qty=" + qty + "]";
	}
}

