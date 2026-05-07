package dto.hq.place_order;


public class PlaceOrderOverviewDTO {
	private Integer poId;				// 발주서 ID
	private String poNo;				// 발주서 번호
	private String branchName;			// 요청 지점
	private String  requestedAt;	// 요청 시점
	private Integer totalItemCnt; 		// 품목 수
	private Integer totalAmounts; 		// 총 수량
	private String status; 				// 처리 상태
	
	@Override
	public String toString() {
		return "PlaceOrderOverviewDTO [poId=" + poId + ", poNo=" + poNo + ", branchName=" + branchName
				+ ", requestedAt=" + requestedAt + ", totalItemCnt=" + totalItemCnt + ", totalAmounts=" + totalAmounts
				+ ", status=" + status + "]";
	}
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
}
