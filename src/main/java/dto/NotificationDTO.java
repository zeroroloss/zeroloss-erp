package dto;

import java.time.LocalDateTime;

public class NotificationDTO {
	private Integer notificationId;
	private Integer accountId;
	private String message;
	private Boolean isRead;
	private LocalDateTime createdAt;

	public NotificationDTO() {
		super();
	}

	public NotificationDTO(Integer notificationId, Integer accountId, String message, Boolean isRead, LocalDateTime createdAt) {
		super();
		this.notificationId = notificationId;
		this.accountId = accountId;
		this.message = message;
		this.isRead = isRead;
		this.createdAt = createdAt;
	}

	public Integer getNotificationId() {
		return notificationId;
	}

	public void setNotificationId(Integer notificationId) {
		this.notificationId = notificationId;
	}

	public Integer getAccountId() {
		return accountId;
	}

	public void setAccountId(Integer accountId) {
		this.accountId = accountId;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Boolean getIsRead() {
		return isRead;
	}

	public void setIsRead(Boolean isRead) {
		this.isRead = isRead;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	@Override
	public String toString() {
		return "NotificationDTO [notificationId=" + notificationId + ", accountId=" + accountId + ", message=" + message + ", isRead=" + isRead + ", createdAt=" + createdAt + "]";
	}
}

