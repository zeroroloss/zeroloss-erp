package dto.hq.branch_stock;

public class BranchStockListDTO {
	private String branchCode;
	private String branchName;
	private String materialCode;
	private String materialName;
	private String categoryName;
	private String unit;
	private double currentQty;
	private double safeStockQty;
	private String status;
	private String lastUpdated;
	private String expireDate;
	private String expireStatus;
	
	public BranchStockListDTO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public BranchStockListDTO(String branchCode, String branchName, String materialCode, String materialName,
			String categoryName, String unit, double currentQty, double safeStockQty, String status,
			String lastUpdated) {
		super();
		this.branchCode = branchCode;
		this.branchName = branchName;
		this.materialCode = materialCode;
		this.materialName = materialName;
		this.categoryName = categoryName;
		this.unit = unit;
		this.currentQty = currentQty;
		this.safeStockQty = safeStockQty;
		this.status = status;
		this.lastUpdated = lastUpdated;
	}

	public String getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(String branchCode) {
		this.branchCode = branchCode;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
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

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public double getCurrentQty() {
		return currentQty;
	}

	public void setCurrentQty(double currentQty) {
		this.currentQty = currentQty;
	}

	public double getSafeStockQty() {
		return safeStockQty;
	}

	public void setSafeStockQty(double safeStockQty) {
		this.safeStockQty = safeStockQty;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getLastUpdated() {
		return lastUpdated;
	}

	public void setLastUpdated(String lastUpdated) {
		this.lastUpdated = lastUpdated;
	}

	public String getExpireDate() {
		return expireDate;
	}

	public void setExpireDate(String expireDate) {
		this.expireDate = expireDate;
	}

	public String getExpireStatus() {
		return expireStatus;
	}

	public void setExpireStatus(String expireStatus) {
		this.expireStatus = expireStatus;
	}
	
	
	
}
