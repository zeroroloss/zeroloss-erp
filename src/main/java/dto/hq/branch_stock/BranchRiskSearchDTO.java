package dto.hq.branch_stock;

public class BranchRiskSearchDTO {
	private Integer branchCode;
	private String startDate;
	private String endDate;
	
	public BranchRiskSearchDTO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public BranchRiskSearchDTO(Integer branchCode, String startDate, String endDate) {
		super();
		this.branchCode = branchCode;
		this.startDate = startDate;
		this.endDate = endDate;
	}

	public Integer getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(Integer branchCode) {
		this.branchCode = branchCode;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	
}
