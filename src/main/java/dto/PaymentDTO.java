package dto;

import java.time.LocalDateTime;

public class PaymentDTO {
	private Integer paymentId;
	private Integer orderId;
	private String payMethod;
	private String cardCompany;
	private String cardNoMasked;
	private String pgApprovalNo;
	private Integer paidAmount;
	private String status;
	private LocalDateTime paidAt;

	public PaymentDTO() {}

	public PaymentDTO(Integer paymentId, Integer orderId, String payMethod, String cardCompany, String cardNoMasked, String pgApprovalNo, Integer paidAmount, String status, LocalDateTime paidAt) {
		super();
		this.paymentId = paymentId;
		this.orderId = orderId;
		this.payMethod = payMethod;
		this.cardCompany = cardCompany;
		this.cardNoMasked = cardNoMasked;
		this.pgApprovalNo = pgApprovalNo;
		this.paidAmount = paidAmount;
		this.status = status;
		this.paidAt = paidAt;
	}

	public Integer getPaymentId() {
		return paymentId;
	}

	public void setPaymentId(Integer paymentId) {
		this.paymentId = paymentId;
	}

	public Integer getOrderId() {
		return orderId;
	}

	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}

	public String getPayMethod() {
		return payMethod;
	}

	public void setPayMethod(String payMethod) {
		this.payMethod = payMethod;
	}

	public String getCardCompany() {
		return cardCompany;
	}

	public void setCardCompany(String cardCompany) {
		this.cardCompany = cardCompany;
	}

	public String getCardNoMasked() {
		return cardNoMasked;
	}

	public void setCardNoMasked(String cardNoMasked) {
		this.cardNoMasked = cardNoMasked;
	}

	public String getPgApprovalNo() {
		return pgApprovalNo;
	}

	public void setPgApprovalNo(String pgApprovalNo) {
		this.pgApprovalNo = pgApprovalNo;
	}

	public Integer getPaidAmount() {
		return paidAmount;
	}

	public void setPaidAmount(Integer paidAmount) {
		this.paidAmount = paidAmount;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public LocalDateTime getPaidAt() {
		return paidAt;
	}

	public void setPaidAt(LocalDateTime paidAt) {
		this.paidAt = paidAt;
	}

	@Override
	public String toString() {
		return "PaymentDTO [paymentId=" + paymentId + ", orderId=" + orderId + ", payMethod=" + payMethod + ", cardCompany=" + cardCompany + ", cardNoMasked=" + cardNoMasked + ", pgApprovalNo=" + pgApprovalNo + ", paidAmount=" + paidAmount + ", status=" + status + ", paidAt=" + paidAt + "]";
	}
}

