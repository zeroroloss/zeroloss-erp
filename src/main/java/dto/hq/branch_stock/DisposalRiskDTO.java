package dto.hq.branch_stock;

public class DisposalRiskDTO {
	private String disposalDate;
    private String branchName;
    private String materialName;
    private Integer qty;
    private Integer lossAmount;
    private String reason;
	 
	public DisposalRiskDTO() { }

	public DisposalRiskDTO(String disposalDate, String branchName, String materialName, Integer qty, Integer lossAmount,
			String reason) {
		super();
		this.disposalDate = disposalDate;
		this.branchName = branchName;
		this.materialName = materialName;
		this.qty = qty;
		this.lossAmount = lossAmount;
		this.reason = reason;
	}

	public String getDisposalDate() {
		return disposalDate;
	}

	public void setDisposalDate(String disposalDate) {
		this.disposalDate = disposalDate;
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

	public Integer getLossAmount() {
		return lossAmount;
	}

	public void setLossAmount(Integer lossAmount) {
		this.lossAmount = lossAmount;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}
	
}
