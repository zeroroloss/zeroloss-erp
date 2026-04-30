package dto.branch.place_order;

import java.time.LocalDateTime;
import java.util.List;

public class PlaceOrderDraftDTO {
	Integer draftId;
	Integer branchCode;
	String status; // IN_PROGRESS / COMPLETED / ABANDONED
	Integer poId;
	
	LocalDateTime createdAt;
	LocalDateTime updatedAt;
	
	//
	List<PlaceOrderDraftDetailDTO> details;

	public PlaceOrderDraftDTO() {
		super();
	}

	public PlaceOrderDraftDTO(int draftId, int branchCode, String status, int poId, LocalDateTime createdAt,
			LocalDateTime updatedAt, List<PlaceOrderDraftDetailDTO> details) {
		super();
		this.draftId = draftId;
		this.branchCode = branchCode;
		this.status = status;
		this.poId = poId;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
		this.details = details;
	}

	@Override
	public String toString() {
		return "PlaceOrderDraftDTO [draftId=" + draftId + ", branchCode=" + branchCode + ", status=" + status
				+ ", poId=" + poId + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + ", details=" + details
				+ "]";
	}
	//
	public Integer getDraftId() {
		return draftId;
	}

	public void setDraftId(int draftId) {
		this.draftId = draftId;
	}

	public Integer getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(int branchCode) {
		this.branchCode = branchCode;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Integer getPoId() {
		return poId;
	}

	public void setPoId(int poId) {
		this.poId = poId;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public LocalDateTime getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(LocalDateTime updatedAt) {
		this.updatedAt = updatedAt;
	}

	public List<PlaceOrderDraftDetailDTO> getDetails() {
		return details;
	}

	public void setDetails(List<PlaceOrderDraftDetailDTO> details) {
		this.details = details;
	}

	
	
}
