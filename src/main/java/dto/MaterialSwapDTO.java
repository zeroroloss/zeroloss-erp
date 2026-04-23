package dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class MaterialSwapDTO {
	private Integer swapId;
	private Integer reqBranchCode;
	private Integer resBranchCode;
	private String materialCode;
	private BigDecimal qty;
	private String status;
	private LocalDateTime reqDate;

	public MaterialSwapDTO() {
		super();
	}

	public MaterialSwapDTO(Integer swapId, Integer reqBranchCode, Integer resBranchCode, String materialCode, BigDecimal qty, String status, LocalDateTime reqDate) {
		super();
		this.swapId = swapId;
		this.reqBranchCode = reqBranchCode;
		this.resBranchCode = resBranchCode;
		this.materialCode = materialCode;
		this.qty = qty;
		this.status = status;
		this.reqDate = reqDate;
	}

	public Integer getSwapId() {
		return swapId;
	}

	public void setSwapId(Integer swapId) {
		this.swapId = swapId;
	}

	public Integer getReqBranchCode() {
		return reqBranchCode;
	}

	public void setReqBranchCode(Integer reqBranchCode) {
		this.reqBranchCode = reqBranchCode;
	}

	public Integer getResBranchCode() {
		return resBranchCode;
	}

	public void setResBranchCode(Integer resBranchCode) {
		this.resBranchCode = resBranchCode;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public LocalDateTime getReqDate() {
		return reqDate;
	}

	public void setReqDate(LocalDateTime reqDate) {
		this.reqDate = reqDate;
	}

	@Override
	public String toString() {
		return "MaterialSwapDTO [swapId=" + swapId + ", reqBranchCode=" + reqBranchCode + ", resBranchCode=" + resBranchCode + ", materialCode=" + materialCode + ", qty=" + qty + ", status=" + status + ", reqDate=" + reqDate + "]";
	}
}

