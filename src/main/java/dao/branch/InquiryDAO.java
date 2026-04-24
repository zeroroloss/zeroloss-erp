package dao.branch;

import dto.InquiryDTO;
import dto.InquiryReplyDTO;
import java.util.List;
import java.util.Map;

public interface InquiryDAO {
    List<InquiryDTO> selectInquiries(Map<String, Object> params);
    InquiryDTO selectInquiryById(int inquiryId);
    int createInquiry(InquiryDTO inquiry);
    int updateInquiry(InquiryDTO inquiry);
    int deleteInquiry(int inquiryId);
    int createReply(InquiryReplyDTO reply);
    int updateInquiryStatus(Map<String, Object> params);
}