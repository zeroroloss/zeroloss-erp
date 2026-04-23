package dto;

import java.time.LocalDateTime;

public class HqOutboundDTO {
	private Integer hqOutboundNo;
	private String poNo;
	private Integer branchCode;
	private String status;
	private String handler;
	private LocalDateTime shippedAt;

	public HqOutboundDTO() {
		super();
	}

	public HqOutboundDTO(Integer hqOutboundNo, String poNo, Integer branchCode, String status, String handler, LocalDateTime shippedAt) {
		super();
		this.hqOutboundNo = hqOutboundNo;
		this.poNo = poNo;
		this.branchCode = branchCode;
		this.status = status;
		this.handler = handler;
		this.shippedAt = shippedAt;
	}

	public Integer getHqOutboundNo() {
		return hqOutboundNo;
	}

	public void setHqOutboundNo(Integer hqOutboundNo) {
		this.hqOutboundNo = hqOutboundNo;
	}

	public String getPoNo() {
		return poNo;
	}

	public void setPoNo(String poNo) {
		this.poNo = poNo;
	}

	public Integer getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(Integer branchCode) {
		this.branchCode = branchCode;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getHandler() {
		return handler;
	}

	public void setHandler(String handler) {
		this.handler = handler;
	}

	public LocalDateTime getShippedAt() {
		return shippedAt;
	}

	public void setShippedAt(LocalDateTime shippedAt) {
		this.shippedAt = shippedAt;
	}

	@Override
	public String toString() {
		return "HqOutboundDTO [hqOutboundNo=" + hqOutboundNo + ", poNo=" + poNo + ", branchCode=" + branchCode + ", status=" + status + ", handler=" + handler + ", shippedAt=" + shippedAt + "]";
	}
}

