package controller.branch.support;

import com.google.gson.Gson;
import dto.AccountDTO;
import dto.InquiryDTO;
import dto.InquiryReplyDTO;
import org.apache.ibatis.session.SqlSession;
import service.branch.InquiryService;
import service.branch.InquiryServiceImpl;
import util.GsonFactory;
import util.MyBatisSqlSessionFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/branch/support/branch-inquiries-data")
public class BranchInquiryController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	private final InquiryService inquiryService = new InquiryServiceImpl();
    private final Gson gson = GsonFactory.getGson();
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");


    private AccountDTO getLoginUser(HttpServletRequest req) {
        HttpSession session = req.getSession();
        return (AccountDTO) session.getAttribute("loginUser");
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

                String branchCodeStr = req.getParameter("branchCode");
                int branchCode;

                if (branchCodeStr != null && !branchCodeStr.equals("all")) {
                    branchCode = Integer.parseInt(branchCodeStr);
                } else if ("all".equals(branchCodeStr)) {
                    branchCode = 0; // 0은 전체 조회를 의미
                } else {
                    branchCode = (loginUser != null) ? loginUser.getBranchCode() : 0;
                }

                List<InquiryDTO> inquiries = inquiryService.getInquiries(branchCode, filters);
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
        if (loginUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

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

                    if (newInquiry.getInquiryId() > 0) {
                        String title = "[문의 등록] " + newInquiry.getTitle();
                        String message =
                                loginUser.getBranchName()
                                + " 지점에서 새로운 문의가 등록되었습니다.\n"
                                + "[문의유형:" + newInquiry.getCategory() + ", "
                                + "긴급도:" + newInquiry.getUrgency()+"]";
                        try {
                            insertInquiryNotification(title, message, newInquiry.getInquiryId());
                        } catch (SQLException e) {
                            System.err.println("Failed to create inquiry notification: " + e.getMessage());
                        }
                    }

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

    private void insertInquiryNotification(String title, String message, int targetId) throws SQLException {
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
        try {
            Connection conn = sqlSession.getConnection();

            String notifSql = "INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
            try (PreparedStatement ps = conn.prepareStatement(notifSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, "BOARD");
                ps.setString(2, title);
                ps.setString(3, message);
                ps.setString(4, "INQUIRY");
                ps.setInt(5, targetId);
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        int notifId = keys.getInt(1);
                        String recvSql = "INSERT INTO notification_receiver (notification_id, account_id, is_read) SELECT ?, account_id, FALSE FROM account WHERE branch_code = 1";
                        try (PreparedStatement ps2 = conn.prepareStatement(recvSql)) {
                            ps2.setInt(1, notifId);
                            ps2.executeUpdate();
                        }
                    }
                }
            }
            sqlSession.commit();
        } catch (SQLException e) {
            sqlSession.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    private void handleException(HttpServletResponse resp, Exception e) throws IOException {
        e.printStackTrace();
        resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        resp.getWriter().write("{\"message\": \"An error occurred: " + e.getMessage() + "\"}");
    }
}
