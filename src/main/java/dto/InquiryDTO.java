package dto;

import java.time.LocalDateTime;

public class InquiryDTO {
	private Integer inquiryId;
	private Integer branchCode;
	private String title;
	private String content;
	private String status;
	private LocalDateTime createdAt;

	public InquiryDTO() {
		super();
	}

	public InquiryDTO(Integer inquiryId, Integer branchCode, String title, String content, String status, LocalDateTime createdAt) {
		super();
		this.inquiryId = inquiryId;
		this.branchCode = branchCode;
		this.title = title;
		this.content = content;
		this.status = status;
		this.createdAt = createdAt;
	}

	public Integer getInquiryId() {
		return inquiryId;
	}

	public void setInquiryId(Integer inquiryId) {
		this.inquiryId = inquiryId;
	}

	public Integer getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(Integer branchCode) {
		this.branchCode = branchCode;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	@Override
	public String toString() {
		return "InquiryDTO [inquiryId=" + inquiryId + ", branchCode=" + branchCode + ", title=" + title + ", content=" + content + ", status=" + status + ", createdAt=" + createdAt + "]";
	}
}

