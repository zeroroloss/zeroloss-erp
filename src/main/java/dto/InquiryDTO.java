package dto;

import java.util.List;

public class InquiryDTO {
    private int inquiryId;
    private int branchCode;
    private String branchName;
    private String title;
    private String content;
    private String category;
    private String urgency;
    private String status;
    private String createdAt;
    private String updatedAt;
    private List<InquiryReplyDTO> replies;

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
    public String getUpdatedAt() { return updatedAt; } // 🟢 Getter
    public void setUpdatedAt(String updatedAt) { this.updatedAt = updatedAt; } // 🟢 Setter
    public List<InquiryReplyDTO> getReplies() { return replies; }
    public void setReplies(List<InquiryReplyDTO> replies) { this.replies = replies; }
}