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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/branch/support/branch-inquiries-data")
public class BranchInquiryController extends HttpServlet {

    private final InquiryService inquiryService = new InquiryServiceImpl();
    private final Gson gson = GsonFactory.getGson();
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");


    private AccountDTO getLoginUser(HttpServletRequest req) {
        HttpSession session = req.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            loginUser = new AccountDTO();
            loginUser.setAccountId(1);
            loginUser.setBranchCode(1); 
        }
        return loginUser;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        AccountDTO loginUser = getLoginUser(req);
        String inquiryId = req.getParameter("id");

        try {
            if (inquiryId != null) {
                InquiryDTO inquiry = inquiryService.getInquiryById(Integer.parseInt(inquiryId));
                resp.getWriter().write(gson.toJson(inquiry));
            } else {
                Map<String, String> filters = new HashMap<>();
                filters.put("category", req.getParameter("category"));
                filters.put("status", req.getParameter("status"));
                filters.put("searchTerm", req.getParameter("searchTerm"));

                List<InquiryDTO> inquiries = inquiryService.getInquiries(loginUser.getBranchCode(), filters);
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

        AccountDTO loginUser = getLoginUser(req);
        String action = req.getParameter("action");
        String requestBody = req.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
        String now = LocalDateTime.now().format(FORMATTER);

        try {
            switch (action) {
                case "create":
                    InquiryDTO newInquiry = gson.fromJson(requestBody, InquiryDTO.class);
                    newInquiry.setBranchCode(loginUser.getBranchCode());
                    newInquiry.setCreatedAt(now);
                    newInquiry.setUpdatedAt(now);
                    inquiryService.createInquiry(newInquiry);
                    resp.setStatus(HttpServletResponse.SC_CREATED);
                    break;

                case "update":
                    InquiryDTO inquiryToUpdate = gson.fromJson(requestBody, InquiryDTO.class);
                    inquiryToUpdate.setUpdatedAt(now);
                    inquiryService.updateInquiry(inquiryToUpdate);
                    resp.setStatus(HttpServletResponse.SC_OK);
                    break;

                case "delete":
                    int inquiryIdToDelete = Integer.parseInt(req.getParameter("id"));
                    inquiryService.deleteInquiry(inquiryIdToDelete);
                    resp.setStatus(HttpServletResponse.SC_OK);
                    break;

                case "createReply":
                    InquiryReplyDTO newReply = gson.fromJson(requestBody, InquiryReplyDTO.class);
                    newReply.setAuthorId(loginUser.getAccountId());
                    newReply.setCreatedAt(now);
                    inquiryService.createReply(newReply);
                    resp.setStatus(HttpServletResponse.SC_CREATED);
                    break;

                default:
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
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