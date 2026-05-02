package dto.hq.place_order;

import java.util.List;

public class PlaceOrderOverviewDetailDTO {
	private Integer poId;
	private String poNo;
	private String branchName;
	private String requestedAt;
	private String status;
	private Integer totalItemCnt;
	private Integer totalAmounts;

	private List<PlaceOrderOverviewMaterialDTO> items ;

	public Integer getPoId() {
		return poId;
	}

	public void setPoId(Integer poId) {
		this.poId = poId;
	}

	public String getPoNo() {
		return poNo;
	}

	public void setPoNo(String poNo) {
		this.poNo = poNo;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	public String getRequestedAt() {
		return requestedAt;
	}

	public void setRequestedAt(String requestedAt) {
		this.requestedAt = requestedAt;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Integer getTotalItemCnt() {
		return totalItemCnt;
	}

	public void setTotalItemCnt(Integer totalItemCnt) {
		this.totalItemCnt = totalItemCnt;
	}

	public Integer getTotalAmounts() {
		return totalAmounts;
	}

	public void setTotalAmounts(Integer totalAmounts) {
		this.totalAmounts = totalAmounts;
	}

	public List<PlaceOrderOverviewMaterialDTO> getItems() {
		return items;
	}

	public void setItems(List<PlaceOrderOverviewMaterialDTO> items) {
		this.items = items;
	}

	@Override
	public String toString() {
		return "PlaceOrderOverviewDetailDTO [poId=" + poId + ", poNo=" + poNo + ", branchName=" + branchName
				+ ", requestedAt=" + requestedAt + ", status=" + status + ", totalItemCnt=" + totalItemCnt
				+ ", totalAmounts=" + totalAmounts + ", items=" + items + "]";
	}

	
}
