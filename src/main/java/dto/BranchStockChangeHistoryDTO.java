package dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class BranchStockChangeHistoryDTO {
	private Integer changeId;
	private String branchStockCode;
	private BigDecimal changeAmount;
	private String changeType;
	private LocalDateTime changedAt;

	// join 필드 추가
	private BigDecimal afterQty;
	private String materialName;
	private String groupName;
	private String expireDate;

	public BranchStockChangeHistoryDTO() {
		super();
	}
	public BranchStockChangeHistoryDTO(Integer changeId, String branchStockCode, BigDecimal changeAmount,
			String changeType, LocalDateTime changedAt, BigDecimal afterQty, String materialName, String groupName,
			String expireDate) {
		super();
		this.changeId = changeId;
		this.branchStockCode = branchStockCode;
		this.changeAmount = changeAmount;
		this.changeType = changeType;
		this.changedAt = changedAt;
		this.afterQty = afterQty;
		this.materialName = materialName;
		this.groupName = groupName;
		this.expireDate = expireDate;
	}
	
	public Integer getChangeId() {
		return changeId;
	}
	public void setChangeId(Integer changeId) {
		this.changeId = changeId;
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
	public String getChangeType() {
		return changeType;
	}
	public void setChangeType(String changeType) {
		this.changeType = changeType;
	}
	public LocalDateTime getChangedAt() {
		return changedAt;
	}
	public void setChangedAt(LocalDateTime changedAt) {
		this.changedAt = changedAt;
	}
	public BigDecimal getAfterQty() {
		return afterQty;
	}
	public void setAfterQty(BigDecimal afterQty) {
		this.afterQty = afterQty;
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
		return "BranchStockChangeHistoryDTO [changeId=" + changeId + ", branchStockCode=" + branchStockCode
				+ ", changeAmount=" + changeAmount + ", changeType=" + changeType + ", changedAt=" + changedAt
				+ ", afterQty=" + afterQty + ", materialName=" + materialName + ", groupName=" + groupName
				+ ", expireDate=" + expireDate + "]";
	}
}
