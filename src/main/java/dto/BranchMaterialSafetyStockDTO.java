package dto;

import java.math.BigDecimal;

public class BranchMaterialSafetyStockDTO {
	private Integer branchCode;
	private String materialCode;
	private BigDecimal safeStockQty;

	public BranchMaterialSafetyStockDTO() {
		super();
	}

	public BranchMaterialSafetyStockDTO(Integer branchCode, String materialCode, BigDecimal safeStockQty) {
		super();
		this.branchCode = branchCode;
		this.materialCode = materialCode;
		this.safeStockQty = safeStockQty;
	}

	public Integer getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(Integer branchCode) {
		this.branchCode = branchCode;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	public BigDecimal getSafeStockQty() {
		return safeStockQty;
	}

	public void setSafeStockQty(BigDecimal safeStockQty) {
		this.safeStockQty = safeStockQty;
	}

	@Override
	public String toString() {
		return "BranchMaterialSafetyStockDTO [branchCode=" + branchCode + ", materialCode=" + materialCode + ", safeStockQty=" + safeStockQty + "]";
	}
}

