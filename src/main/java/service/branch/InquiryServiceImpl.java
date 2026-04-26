package service.branch;

import dao.branch.InquiryDAO;
import dao.branch.InquiryDAOImpl;
import dto.InquiryDTO;
import dto.InquiryReplyDTO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class InquiryServiceImpl implements InquiryService {

    private final InquiryDAO inquiryDAO = new InquiryDAOImpl();
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    public List<InquiryDTO> getInquiries(int branchCode, Map<String, String> filters) {
        Map<String, Object> params = new HashMap<>(filters);
        // branchCode가 0이면 모든 지점의 문의를 조회하도록 DAO에 전달
        if (branchCode != 0) {
            params.put("branchCode", branchCode);
        }
        return inquiryDAO.selectInquiries(params);
    }

    @Override
    public InquiryDTO getInquiryById(int inquiryId) {
        return inquiryDAO.selectInquiryById(inquiryId);
    }

    @Override
    public void createInquiry(InquiryDTO inquiry) {
        inquiryDAO.createInquiry(inquiry);
    }

    @Override
    public void updateInquiry(InquiryDTO inquiry) {
        inquiryDAO.updateInquiry(inquiry);
    }

    @Override
    public void deleteInquiry(int inquiryId) {
        inquiryDAO.deleteInquiry(inquiryId);
    }

    @Override
    public void createReply(InquiryReplyDTO reply) {
        inquiryDAO.createReply(reply);
        
        // 답변이 달리면 문의 상태와 수정 시간을 함께 업데이트
        Map<String, Object> params = new HashMap<>();
        params.put("inquiryId", reply.getInquiryId());
        params.put("status", "답변 완료");
        params.put("updatedAt", LocalDateTime.now().format(FORMATTER));
        inquiryDAO.updateInquiryStatus(params);
    }

    @Override
    public void createReplyAndUpdateStatus(InquiryReplyDTO reply, String newStatus) {
        // 1. 답변 생성
        inquiryDAO.createReply(reply);

        // 2. 문의 상태 및 최종 수정 시간 업데이트
        Map<String, Object> params = new HashMap<>();
        params.put("inquiryId", reply.getInquiryId());
        params.put("status", newStatus);
        params.put("updatedAt", LocalDateTime.now().format(FORMATTER));
        inquiryDAO.updateInquiryStatus(params);
    }
}