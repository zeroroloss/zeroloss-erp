package dto;

import java.time.LocalDateTime;

public class NotificationDTO {
	private Integer notificationId;
	private String category;
	private String title;
	private String message;
	private String targetType;
	private Integer targetId;
	private LocalDateTime createdAt;
	
	private Integer notificationReceiverId;
	private Integer accountId;
	private Integer isRead;
	private LocalDateTime readAt;

	public NotificationDTO() {
		super();
	}

	public NotificationDTO(Integer notificationId, String category, String title, String message, String targetType,
			Integer targetId, LocalDateTime createdAt) {
		super();
		this.notificationId = notificationId;
		this.category = category;
		this.title = title;
		this.message = message;
		this.targetType = targetType;
		this.targetId = targetId;
		this.createdAt = createdAt;
	}

	public Integer getNotificationId() {
		return notificationId;
	}

	public void setNotificationId(Integer notificationId) {
		this.notificationId = notificationId;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getTargetType() {
		return targetType;
	}

	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}

	public Integer getTargetId() {
		return targetId;
	}

	public void setTargetId(Integer targetId) {
		this.targetId = targetId;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public Integer getNotificationReceiverId() {
		return notificationReceiverId;
	}

	public void setNotificationReceiverId(Integer notificationReceiverId) {
		this.notificationReceiverId = notificationReceiverId;
	}

	public Integer getAccountId() {
		return accountId;
	}

	public void setAccountId(Integer accountId) {
		this.accountId = accountId;
	}

	public Integer getIsRead() {
		return isRead;
	}

	public void setIsRead(Integer isRead) {
		this.isRead = isRead;
	}

	public LocalDateTime getReadAt() {
		return readAt;
	}

	public void setReadAt(LocalDateTime readAt) {
		this.readAt = readAt;
	}

	@Override
	public String toString() {
		return "NotificationDTO [notificationId=" + notificationId + ", category=" + category + ", title=" + title
				+ ", message=" + message + ", targetType=" + targetType + ", targetId=" + targetId + ", createdAt="
				+ createdAt + "]";
	}

}

