package dto;

import java.time.LocalDateTime;

public class InquiryReplyDTO {
	private Integer replyId;
	private Integer inquiryId;
	private Integer authorId;
	private String content;
	private LocalDateTime createdAt;

	public InquiryReplyDTO() {
		super();
	}

	public InquiryReplyDTO(Integer replyId, Integer inquiryId, Integer authorId, String content, LocalDateTime createdAt) {
		super();
		this.replyId = replyId;
		this.inquiryId = inquiryId;
		this.authorId = authorId;
		this.content = content;
		this.createdAt = createdAt;
	}

	public Integer getReplyId() {
		return replyId;
	}

	public void setReplyId(Integer replyId) {
		this.replyId = replyId;
	}

	public Integer getInquiryId() {
		return inquiryId;
	}

	public void setInquiryId(Integer inquiryId) {
		this.inquiryId = inquiryId;
	}

	public Integer getAuthorId() {
		return authorId;
	}

	public void setAuthorId(Integer authorId) {
		this.authorId = authorId;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	@Override
	public String toString() {
		return "InquiryReplyDTO [replyId=" + replyId + ", inquiryId=" + inquiryId + ", authorId=" + authorId + ", content=" + content + ", createdAt=" + createdAt + "]";
	}
}

