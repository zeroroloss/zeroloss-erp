package dto.hq.branch_stock;

public class BranchRiskSummaryDTO {
	private Integer urgentCount;
    private Integer warningCount;
    private Integer disposalCount;
	 
	public BranchRiskSummaryDTO() {	}

	public BranchRiskSummaryDTO(Integer urgentCount, Integer warningCount, Integer disposalCount) {
		super();
		this.urgentCount = urgentCount;
		this.warningCount = warningCount;
		this.disposalCount = disposalCount;
	}

	public Integer getUrgentCount() {
		return urgentCount;
	}

	public void setUrgentCount(Integer urgentCount) {
		this.urgentCount = urgentCount;
	}

	public Integer getWarningCount() {
		return warningCount;
	}

	public void setWarningCount(Integer warningCount) {
		this.warningCount = warningCount;
	}

	public Integer getDisposalCount() {
		return disposalCount;
	}

	public void setDisposalCount(Integer disposalCount) {
		this.disposalCount = disposalCount;
	}
	 
}
