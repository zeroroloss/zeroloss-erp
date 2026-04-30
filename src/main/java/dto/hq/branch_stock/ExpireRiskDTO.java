package dto.hq.branch_stock;

public class ExpireRiskDTO {
	private String branchName;
    private String materialName;
    private Integer qty;
    private String expireDate;
    private Integer dDay;
    private String receivedDate;
    private String unit;
    
	public ExpireRiskDTO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public ExpireRiskDTO(String branchName, String materialName, Integer qty, String expireDate, Integer dDay,
			String receivedDate, String unit) {
		super();
		this.branchName = branchName;
		this.materialName = materialName;
		this.qty = qty;
		this.expireDate = expireDate;
		this.dDay = dDay;
		this.receivedDate = receivedDate;
		this.unit = unit;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}

	public Integer getQty() {
		return qty;
	}

	public void setQty(Integer qty) {
		this.qty = qty;
	}

	public String getExpireDate() {
		return expireDate;
	}

	public void setExpireDate(String expireDate) {
		this.expireDate = expireDate;
	}

	public Integer getdDay() {
		return dDay;
	}

	public void setdDay(Integer dDay) {
		this.dDay = dDay;
	}

	public String getReceivedDate() {
		return receivedDate;
	}

	public void setReceivedDate(String receivedDate) {
		this.receivedDate = receivedDate;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

}
