package dto.branch.inbound;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class InboundProcessingItemDTO {
	Integer hqOutboundDetailId;
	String materialCode;	// 재료코드
	String materialName;	// 재료명
	String category;		// 카테고리명
	
	BigDecimal requestedQty;	// 발주 요청 수량
	BigDecimal outboundQty;		// 출고된 수량
	BigDecimal receivedQty; 	// 받은 수량
	String unit;				// 단위
	String stockNo;				// 재고 번호
	String branchStockCode;		// 지점 재고 코드
	
	String expiryDate; 		// 유통기한 일자
	String note; 			// 비고

	public static List<InboundProcessingItemDTO> from(Object rawItems) {
		List<InboundProcessingItemDTO> items = new ArrayList<>();
		if (!(rawItems instanceof List)) {
			return items;
		}

		List<?> rows = (List<?>) rawItems;
		for (Object row : rows) {
			if (!(row instanceof Map)) {
				continue;
			}
			Map<?, ?> map = (Map<?, ?>) row;
			InboundProcessingItemDTO dto = new InboundProcessingItemDTO();
			dto.setHqOutboundDetailId(asInt(map.get("hqOutboundDetailId")));
			dto.setReceivedQty(asDecimal(map.get("receivedQty")));
			dto.setNote(asString(map.get("note")));
			items.add(dto);
		}

		return items;
	}

	private static Integer asInt(Object value) {
		if (value == null) {
			return null;
		}
		if (value instanceof Number) {
			return ((Number) value).intValue();
		}
		return Integer.parseInt(String.valueOf(value));
	}

	private static BigDecimal asDecimal(Object value) {
		if (value == null) {
			return null;
		}
		if (value instanceof BigDecimal) {
			return (BigDecimal) value;
		}
		if (value instanceof Number) {
			return BigDecimal.valueOf(((Number) value).doubleValue());
		}
		return new BigDecimal(String.valueOf(value));
	}

	private static String asString(Object value) {
		return value == null ? null : String.valueOf(value);
	}

	public Integer getHqOutboundDetailId() {
		return hqOutboundDetailId;
	}
	public void setHqOutboundDetailId(Integer hqOutboundDetailId) {
		this.hqOutboundDetailId = hqOutboundDetailId;
	}
	@Override
	public String toString() {
		return "InboundProcessingItemDTO [hqOutboundDetailId=" + hqOutboundDetailId + ", materialCode=" + materialCode + ", materialName=" + materialName
				+ ", category=" + category + ", requestedQty=" + requestedQty + ", outboundQty=" + outboundQty
				+ ", receivedQty=" + receivedQty + ", unit=" + unit + ", stockNo=" + stockNo + ", branchStockCode=" + branchStockCode
				+ ", expiryDate=" + expiryDate + ", note=" + note + "]";
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
	public String getStockNo() {
		return stockNo;
	}
	public void setStockNo(String stockNo) {
		this.stockNo = stockNo;
	}
	public String getBranchStockCode() {
		return branchStockCode;
	}
	public void setBranchStockCode(String branchStockCode) {
		this.branchStockCode = branchStockCode;
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
