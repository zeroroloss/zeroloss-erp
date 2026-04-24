package dto.hq.warehouse;

public class WarehouseStockMovementDTO {
    private Long change_history_id;
    private String stockNo;
    private String changeType;
    private Integer changeAmount;
    private Integer afterQty;
    private String changedAt;
    
	public Long getId() {
		return change_history_id;
	}
	public void setId(Long id) {
		this.change_history_id = id;
	}
	public String getStockNo() {
		return stockNo;
	}
	public void setStockNo(String stockNo) {
		this.stockNo = stockNo;
	}
	public String getChangeType() {
		return changeType;
	}
	public void setChangeType(String changeType) {
		this.changeType = changeType;
	}
	public Integer getChangeAmount() {
		return changeAmount;
	}
	public void setChangeAmount(Integer changeAmount) {
		this.changeAmount = changeAmount;
	}
	public Integer getAfterQty() {
		return afterQty;
	}
	public void setAfterQty(Integer afterQty) {
		this.afterQty = afterQty;
	}
	public String getChangedAt() {
		return changedAt;
	}
	public void setChangedAt(String changedAt) {
		this.changedAt = changedAt;
	}

	@Override
	public String toString() {
	    return "WarehouseStockMovementDTO{" +
	            "changeType='" + changeType + '\'' +
	            ", changeAmount=" + changeAmount +
	            ", afterQty=" + afterQty +
	            ", changedAt='" + changedAt + '\'' +
	            '}';
	}
}
