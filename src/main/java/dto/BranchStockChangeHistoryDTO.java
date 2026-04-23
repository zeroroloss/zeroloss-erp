package dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class BranchStockChangeHistoryDTO {
	private Integer changeId;
	private String branchStockCode;
	private BigDecimal changeAmount;
	private String changeType;
	private LocalDateTime changedAt;

	public BranchStockChangeHistoryDTO() {
		super();
	}

	public BranchStockChangeHistoryDTO(Integer changeId, String branchStockCode, BigDecimal changeAmount, String changeType, LocalDateTime changedAt) {
		super();
		this.changeId = changeId;
		this.branchStockCode = branchStockCode;
		this.changeAmount = changeAmount;
		this.changeType = changeType;
		this.changedAt = changedAt;
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

	@Override
	public String toString() {
		return "BranchStockChangeHistoryDTO [changeId=" + changeId + ", branchStockCode=" + branchStockCode + ", changeAmount=" + changeAmount + ", changeType=" + changeType + ", changedAt=" + changedAt + "]";
	}
}

