package dto;

public class OrderOptionDTO {
	private Integer orderOptionId;
	private Integer orderMenuId;
	private String materialCode;
	private Integer extraPrice;

	public OrderOptionDTO() {}

	public OrderOptionDTO(Integer orderOptionId, Integer orderMenuId, String materialCode, Integer extraPrice) {
		super();
		this.orderOptionId = orderOptionId;
		this.orderMenuId = orderMenuId;
		this.materialCode = materialCode;
		this.extraPrice = extraPrice;
	}

	public Integer getOrderOptionId() {
		return orderOptionId;
	}

	public void setOrderOptionId(Integer orderOptionId) {
		this.orderOptionId = orderOptionId;
	}

	public Integer getOrderMenuId() {
		return orderMenuId;
	}

	public void setOrderMenuId(Integer orderMenuId) {
		this.orderMenuId = orderMenuId;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	public Integer getExtraPrice() {
		return extraPrice;
	}

	public void setExtraPrice(Integer extraPrice) {
		this.extraPrice = extraPrice;
	}

	@Override
	public String toString() {
		return "OrderOptionDTO [orderOptionId=" + orderOptionId + ", orderMenuId=" + orderMenuId + ", materialCode=" + materialCode + ", extraPrice=" + extraPrice + "]";
	}
}

