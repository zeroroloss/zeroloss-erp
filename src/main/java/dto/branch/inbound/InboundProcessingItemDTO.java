package dto.branch.inbound;

import java.math.BigDecimal;

public class InboundProcessingItemDTO {
	String materialCode;	// 재료코드
	String materialName;	// 재료명
	String category;		// 카테고리명
	
	BigDecimal requestedQty;	// 발주 요청 수량
	BigDecimal outboundQty;		// 출고된 수량
	BigDecimal receivedQty; 	// 받은 수량
	String unit;				// 단위
	
	String expiryDate; 		// 유통기한 일자
	String note; 			// 비고
	
	@Override
	public String toString() {
		return "InboundProcessingItemDTO [materialCode=" + materialCode + ", materialName=" + materialName
				+ ", category=" + category + ", requestedQty=" + requestedQty + ", outboundQty=" + outboundQty
				+ ", receivedQty=" + receivedQty + ", unit=" + unit + ", expiryDate=" + expiryDate + ", note=" + note
				+ "]";
	}
	
	public String getMaterialCode() {
		return materialCode;
	}
	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}
	public String getMaterialName() {
		return materialName;
	}
	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public BigDecimal getRequestedQty() {
		return requestedQty;
	}
	public void setRequestedQty(BigDecimal requestedQty) {
		this.requestedQty = requestedQty;
	}
	public BigDecimal getOutboundQty() {
		return outboundQty;
	}
	public void setOutboundQty(BigDecimal outboundQty) {
		this.outboundQty = outboundQty;
	}
	public BigDecimal getReceivedQty() {
		return receivedQty;
	}
	public void setReceivedQty(BigDecimal receivedQty) {
		this.receivedQty = receivedQty;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
	public String getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	
	
	
}
