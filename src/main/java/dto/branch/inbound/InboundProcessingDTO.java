package dto.branch.inbound;

import java.util.List;

public class InboundProcessingDTO {
	
	Integer poId;
	String poNo;
	String requestedAt;			// 발주 요청 일시
	String status;
	String outboundAt;			// 출고 일시
	
	List<InboundProcessingItemDTO> items;

	@Override
	public String toString() {
		return "InboundProcessingDTO [poId=" + poId + ", poNo=" + poNo + ", requestedAt=" + requestedAt + ", status="
				+ status + ", outboundAt=" + outboundAt + ", items=" + items + "]\n";
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

	public String getOutboundAt() {
		return outboundAt;
	}

	public void setOutboundAt(String outboundAt) {
		this.outboundAt = outboundAt;
	}

	public List<InboundProcessingItemDTO> getItems() {
		return items;
	}

	public void setItems(List<InboundProcessingItemDTO> items) {
		this.items = items;
	} 
	
	
}
