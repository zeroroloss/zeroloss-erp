package dto;

public class BranchStockDisposalHistoryDTO {
	private Integer disposalId;
	private Integer changeId;
	private String reason;
	private String reasonDetail;

	public BranchStockDisposalHistoryDTO() {
		super();
	}

	public BranchStockDisposalHistoryDTO(Integer disposalId, Integer changeId, String reason, String reasonDetail) {
		super();
		this.disposalId = disposalId;
		this.changeId = changeId;
		this.reason = reason;
		this.reasonDetail = reasonDetail;
	}

	public Integer getDisposalId() {
		return disposalId;
	}

	public void setDisposalId(Integer disposalId) {
		this.disposalId = disposalId;
	}

	public Integer getChangeId() {
		return changeId;
	}

	public void setChangeId(Integer changeId) {
		this.changeId = changeId;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public String getReasonDetail() {
		return reasonDetail;
	}

	public void setReasonDetail(String reasonDetail) {
		this.reasonDetail = reasonDetail;
	}

	@Override
	public String toString() {
		return "BranchStockDisposalHistoryDTO [disposalId=" + disposalId + ", changeId=" + changeId + ", reason=" + reason + ", reasonDetail=" + reasonDetail + "]";
	}
}

