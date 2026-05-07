package dto;

public class NoticeDTO {
    private int noticeId;
    private int authorId;
    private String authorName;
    private String title;
    private String content;
    private String type;

    private String lastDate;
    private String createdAt;

    private int viewCount;
    private boolean isPinned;

    public NoticeDTO() {}

    public int getNoticeId() { return noticeId; }
    public void setNoticeId(int noticeId) { this.noticeId = noticeId; }
    public int getAuthorId() { return authorId; }
    public void setAuthorId(int authorId) { this.authorId = authorId; }
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    // 🟢 Getter와 Setter의 반환/매개변수 타입도 반드시 String이어야 합니다
    public String getLastDate() { return lastDate; }
    public void setLastDate(String lastDate) { this.lastDate = lastDate; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public int getViewCount() { return viewCount; }
    public void setViewCount(int viewCount) { this.viewCount = viewCount; }
    public boolean isPinned() { return isPinned; }
    public void setPinned(boolean pinned) { this.isPinned = pinned; }

    @Override
    public String toString() {
        return "NoticeDTO{" +
                "noticeId=" + noticeId +
                ", authorId=" + authorId +
                ", title='" + title + '\'' +
                ", createdAt='" + createdAt + '\'' +
                ", lastDate='" + lastDate + '\'' +
                '}';
    }
}