package dto;

public class OrderMenuDTO {
	private Integer orderMenuId;
	private Integer orderId;
	private String recipeCode;
	private Integer qty;
	private Integer unitPrice;
	private Integer lineTotalAmount;

	public OrderMenuDTO() {}

	public OrderMenuDTO(Integer orderMenuId, Integer orderId, String recipeCode, Integer qty, Integer unitPrice, Integer lineTotalAmount) {
		super();
		this.orderMenuId = orderMenuId;
		this.orderId = orderId;
		this.recipeCode = recipeCode;
		this.qty = qty;
		this.unitPrice = unitPrice;
		this.lineTotalAmount = lineTotalAmount;
	}

	public Integer getOrderMenuId() {
		return orderMenuId;
	}

	public void setOrderMenuId(Integer orderMenuId) {
		this.orderMenuId = orderMenuId;
	}

	public Integer getOrderId() {
		return orderId;
	}

	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}

	public String getRecipeCode() {
		return recipeCode;
	}

	public void setRecipeCode(String recipeCode) {
		this.recipeCode = recipeCode;
	}

	public Integer getQty() {
		return qty;
	}

	public void setQty(Integer qty) {
		this.qty = qty;
	}

	public Integer getUnitPrice() {
		return unitPrice;
	}

	public void setUnitPrice(Integer unitPrice) {
		this.unitPrice = unitPrice;
	}

	public Integer getLineTotalAmount() {
		return lineTotalAmount;
	}

	public void setLineTotalAmount(Integer lineTotalAmount) {
		this.lineTotalAmount = lineTotalAmount;
	}

	@Override
	public String toString() {
		return "OrderMenuDTO [orderMenuId=" + orderMenuId + ", orderId=" + orderId + ", recipeCode=" + recipeCode + ", qty=" + qty + ", unitPrice=" + unitPrice + ", lineTotalAmount=" + lineTotalAmount + "]";
	}
}

