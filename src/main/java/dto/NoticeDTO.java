package dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class NoticeDTO {
	private Integer noticeId;
	private Integer authorId;
	private String title;
	private String content;
	private Boolean isUrgent;
	private LocalDate lastDate;
	private LocalDateTime createdAt;

	public NoticeDTO() {
		super();
	}

	public NoticeDTO(Integer noticeId, Integer authorId, String title, String content, Boolean isUrgent, LocalDate lastDate, LocalDateTime createdAt) {
		super();
		this.noticeId = noticeId;
		this.authorId = authorId;
		this.title = title;
		this.content = content;
		this.isUrgent = isUrgent;
		this.lastDate = lastDate;
		this.createdAt = createdAt;
	}

	public Integer getNoticeId() {
		return noticeId;
	}

	public void setNoticeId(Integer noticeId) {
		this.noticeId = noticeId;
	}

	public Integer getAuthorId() {
		return authorId;
	}

	public void setAuthorId(Integer authorId) {
		this.authorId = authorId;
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

	public Boolean getIsUrgent() {
		return isUrgent;
	}

	public void setIsUrgent(Boolean isUrgent) {
		this.isUrgent = isUrgent;
	}

	public LocalDate getLastDate() {
		return lastDate;
	}

	public void setLastDate(LocalDate lastDate) {
		this.lastDate = lastDate;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	@Override
	public String toString() {
		return "NoticeDTO [noticeId=" + noticeId + ", authorId=" + authorId + ", title=" + title + ", content=" + content + ", isUrgent=" + isUrgent + ", lastDate=" + lastDate + ", createdAt=" + createdAt + "]";
	}
}

