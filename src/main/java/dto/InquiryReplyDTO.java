package dto;

public class InquiryReplyDTO {
    private int replyId;
    private int inquiryId;
    private int authorId;
    private String authorName;
    private String authorAffiliation;
    private String content;
    private String createdAt;

    public int getReplyId() { return replyId; }
    public void setReplyId(int replyId) { this.replyId = replyId; }
    public int getInquiryId() { return inquiryId; }
    public void setInquiryId(int inquiryId) { this.inquiryId = inquiryId; }
    public int getAuthorId() { return authorId; }
    public void setAuthorId(int authorId) { this.authorId = authorId; }
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
    public String getAuthorAffiliation() { return authorAffiliation; }
    public void setAuthorAffiliation(String authorAffiliation) { this.authorAffiliation = authorAffiliation; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}