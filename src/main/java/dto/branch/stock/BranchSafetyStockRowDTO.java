package dto.branch.stock;

import java.math.BigDecimal;

public class BranchSafetyStockRowDTO {

	private String branchStockCode;
	private String materialCode;
	private String categoryName;
	private String materialName;
	private String unit;
	private BigDecimal safeStockQty;

	public String getBranchStockCode() {
		return branchStockCode;
	}

	public void setBranchStockCode(String branchStockCode) {
		this.branchStockCode = branchStockCode;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public BigDecimal getSafeStockQty() {
		return safeStockQty;
	}

	public void setSafeStockQty(BigDecimal safeStockQty) {
		this.safeStockQty = safeStockQty;
	}
}