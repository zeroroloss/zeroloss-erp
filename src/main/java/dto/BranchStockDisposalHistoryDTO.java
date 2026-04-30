package dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class BranchStockDisposalHistoryDTO {
	private Integer disposalId;
	private Integer changeId;
	private String reason;
	private String reasonDetail;
	
	//join 필드 추가
	private String branchStockCode;
	private BigDecimal changeAmount;
	private LocalDateTime changedAt;
	private String materialName;
	private String groupName;
	private String expireDate;

	public BranchStockDisposalHistoryDTO() {
		super();
	}
	public BranchStockDisposalHistoryDTO(Integer disposalId, Integer changeId, String reason, String reasonDetail,
			String branchStockCode, BigDecimal changeAmount, LocalDateTime changedAt, String materialName,
			String groupName, String expireDate) {
		super();
		this.disposalId = disposalId;
		this.changeId = changeId;
		this.reason = reason;
		this.reasonDetail = reasonDetail;
		this.branchStockCode = branchStockCode;
		this.changeAmount = changeAmount;
		this.changedAt = changedAt;
		this.materialName = materialName;
		this.groupName = groupName;
		this.expireDate = expireDate;
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
	public String getBranchStockCode() {
		return branchStockCode;
	}
	public void setBranchStockCode(String branchStockCode) {
		this.branchStockCode = branchStockCode;
	}
	public BigDecimal getChangeAmount() {
		return changeAmount;
	}
	public void setChangeAmount(BigDecimal changeAmount) {
		this.changeAmount = changeAmount;
	}
	public LocalDateTime getChangedAt() {
		return changedAt;
	}
	public void setChangedAt(LocalDateTime changedAt) {
		this.changedAt = changedAt;
	}
	public String getMaterialName() {
		return materialName;
	}
	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}
	public String getGroupName() {
		return groupName;
	}
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	public String getExpireDate() {
		return expireDate;
	}
	public void setExpireDate(String expireDate) {
		this.expireDate = expireDate;
	}
	
	@Override
	public String toString() {
		return "BranchStockDisposalHistoryDTO [disposalId=" + disposalId + ", changeId=" + changeId + ", reason="
				+ reason + ", reasonDetail=" + reasonDetail + ", branchStockCode=" + branchStockCode + ", changeAmount="
				+ changeAmount + ", changedAt=" + changedAt + ", materialName=" + materialName + ", groupName="
				+ groupName + ", expireDate=" + expireDate + "]";
	}
}

