package dto;

import java.time.LocalDate;
import java.time.LocalTime;

public class OrderDTO {
	private Integer orderId;
	private Integer branchCode;
	private Integer kioskId;
	private String orderSeq;
	private String orderType;
	private Integer totalAmount;
	private String status;
	private LocalDate orderDate;
	private LocalTime createdAt;
	private Boolean isReceipt;

	public OrderDTO() {}

	public OrderDTO(Integer orderId, Integer branchCode, Integer kioskId, String orderSeq, String orderType, Integer totalAmount, String status, LocalDate orderDate, LocalTime createdAt, Boolean isReceipt) {
		super();
		this.orderId = orderId;
		this.branchCode = branchCode;
		this.kioskId = kioskId;
		this.orderSeq = orderSeq;
		this.orderType = orderType;
		this.totalAmount = totalAmount;
		this.status = status;
		this.orderDate = orderDate;
		this.createdAt = createdAt;
		this.isReceipt = isReceipt;
	}

	public Integer getOrderId() {
		return orderId;
	}

	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}

	public Integer getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(Integer branchCode) {
		this.branchCode = branchCode;
	}

	public Integer getKioskId() {
		return kioskId;
	}

	public void setKioskId(Integer kioskId) {
		this.kioskId = kioskId;
	}

	public String getOrderSeq() {
		return orderSeq;
	}

	public void setOrderSeq(String orderSeq) {
		this.orderSeq = orderSeq;
	}

	public String getOrderType() {
		return orderType;
	}

	public void setOrderType(String orderType) {
		this.orderType = orderType;
	}

	public Integer getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(Integer totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public LocalDate getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(LocalDate orderDate) {
		this.orderDate = orderDate;
	}

	public LocalTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalTime createdAt) {
		this.createdAt = createdAt;
	}

	public Boolean getIsReceipt() {
		return isReceipt;
	}

	public void setIsReceipt(Boolean isReceipt) {
		this.isReceipt = isReceipt;
	}

	@Override
	public String toString() {
		return "OrderDTO [orderId=" + orderId + ", branchCode=" + branchCode + ", kioskId=" + kioskId + ", orderSeq=" + orderSeq + ", orderType=" + orderType + ", totalAmount=" + totalAmount + ", status=" + status + ", orderDate=" + orderDate + ", createdAt=" + createdAt + ", isReceipt=" + isReceipt + "]";
	}
}

