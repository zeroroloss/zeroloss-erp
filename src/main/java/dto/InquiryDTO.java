package dto;

import java.util.List;

public class InquiryDTO {
    private int inquiryId;
    private int branchCode;
    private String branchName; // JOIN을 통해 가져올 지점명
    private String title;
    private String content;
    private String category;
    private String urgency;
    private String status;
    private String createdAt;
    private List<InquiryReplyDTO> replies; // 답변 목록

    // Getters and Setters
    public int getInquiryId() { return inquiryId; }
    public void setInquiryId(int inquiryId) { this.inquiryId = inquiryId; }
    public int getBranchCode() { return branchCode; }
    public void setBranchCode(int branchCode) { this.branchCode = branchCode; }
    public String getBranchName() { return branchName; }
    public void setBranchName(String branchName) { this.branchName = branchName; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getUrgency() { return urgency; }
    public void setUrgency(String urgency) { this.urgency = urgency; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    public List<InquiryReplyDTO> getReplies() { return replies; }
    public void setReplies(List<InquiryReplyDTO> replies) { this.replies = replies; }
}