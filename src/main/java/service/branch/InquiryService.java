package service.branch;

import dto.InquiryDTO;
import dto.InquiryReplyDTO;
import java.util.List;
import java.util.Map;

public interface InquiryService {
    List<InquiryDTO> getInquiries(int branchCode, Map<String, String> filters);
    InquiryDTO getInquiryById(int inquiryId);
    void createInquiry(InquiryDTO inquiry);
    void updateInquiry(InquiryDTO inquiry);
    void deleteInquiry(int inquiryId);
    void createReply(InquiryReplyDTO reply);
}