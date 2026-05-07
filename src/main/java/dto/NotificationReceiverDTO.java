package dto;

import java.time.LocalDateTime;

public class NotificationReceiverDTO {
	private Integer notificationReceiverId;
	private Integer notificationId;
	private Integer accountId;
	private Integer isRead;
	private LocalDateTime readAt;
	
	public NotificationReceiverDTO() {}

	public NotificationReceiverDTO(Integer notificationReceiverId, Integer notificationId, Integer accountId,
			Integer isRead, LocalDateTime readAt) {
		super();
		this.notificationReceiverId = notificationReceiverId;
		this.notificationId = notificationId;
		this.accountId = accountId;
		this.isRead = isRead;
		this.readAt = readAt;
	}

	public Integer getNotificationReceiverId() {
		return notificationReceiverId;
	}

	public void setNotificationReceiverId(Integer notificationReceiverId) {
		this.notificationReceiverId = notificationReceiverId;
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
		return "NotificationReceiverDTO [notificationReceiverId=" + notificationReceiverId + ", notificationId="
				+ notificationId + ", accountId=" + accountId + ", isRead=" + isRead + ", readAt=" + readAt + "]";
	}

}
