package controller.branch.support;

import com.google.gson.Gson;
import dto.AccountDTO;
import dto.InquiryDTO;
import dto.InquiryReplyDTO;
import service.branch.InquiryService;
import service.branch.InquiryServiceImpl;
import util.GsonFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/branch/support/branch-inquiries-data")
public class BranchInquiryController extends HttpServlet {

    private final InquiryService inquiryService = new InquiryServiceImpl();
    private final Gson gson = GsonFactory.getGson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");
        // TODO: 로그인 정보 없을 시 예외 처리

        String inquiryId = req.getParameter("id");

        try {
            if (inquiryId != null) {
                // 특정 문의 상세 조회
                InquiryDTO inquiry = inquiryService.getInquiryById(Integer.parseInt(inquiryId));
                resp.getWriter().write(gson.toJson(inquiry));
            } else {
                // 문의 목록 조회
                Map<String, String> filters = new HashMap<>();
                filters.put("category", req.getParameter("category"));
                filters.put("status", req.getParameter("status"));
                filters.put("searchTerm", req.getParameter("searchTerm"));
                List<InquiryDTO> inquiries = inquiryService.getInquiries(0, filters);
                resp.getWriter().write(gson.toJson(inquiries));
            }
        } catch (Exception e) {
            handleException(resp, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");
        // TODO: 로그인 정보 없을 시 예외 처리

        String action = req.getParameter("action");
        String requestBody = req.getReader().lines().collect(Collectors.joining(System.lineSeparator()));

        try {
            switch (action) {
                case "create":
                    InquiryDTO newInquiry = gson.fromJson(requestBody, InquiryDTO.class);
                    newInquiry.setBranchCode(loginUser.getBranchCode());
                    inquiryService.createInquiry(newInquiry);
                    resp.setStatus(HttpServletResponse.SC_CREATED);
                    break;
                case "update":
                    InquiryDTO inquiryToUpdate = gson.fromJson(requestBody, InquiryDTO.class);
                    // TODO: 수정 권한 체크 (작성자 본인 또는 관리자)
                    inquiryService.updateInquiry(inquiryToUpdate);
                    resp.setStatus(HttpServletResponse.SC_OK);
                    break;
                case "delete":
                    int inquiryIdToDelete = Integer.parseInt(req.getParameter("id"));
                    // TODO: 삭제 권한 체크
                    inquiryService.deleteInquiry(inquiryIdToDelete);
                    resp.setStatus(HttpServletResponse.SC_OK);
                    break;
                case "createReply":
                    InquiryReplyDTO newReply = gson.fromJson(requestBody, InquiryReplyDTO.class);

                    InquiryDTO targetInquiry = inquiryService.getInquiryById(newReply.getInquiryId());

                    if (targetInquiry == null || (loginUser.getBranchCode() != 1 && targetInquiry.getBranchCode() != loginUser.getBranchCode())) {
                        resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        resp.getWriter().write("{\"message\": \"본인의 문의사항에만 답변을 달 수 있습니다.\"}");
                        return;
                    }

                    newReply.setAuthorId(loginUser.getAccountId());
                    inquiryService.createReply(newReply);
                    resp.setStatus(HttpServletResponse.SC_CREATED);
                    break;

                default:
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"message\": \"Invalid action\"}");
                    break;
            }
        } catch (Exception e) {
            handleException(resp, e);
        }
    }

    private void handleException(HttpServletResponse resp, Exception e) throws IOException {
        e.printStackTrace();
        resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        resp.getWriter().write("{\"message\": \"An error occurred: " + e.getMessage() + "\"}");
    }
}