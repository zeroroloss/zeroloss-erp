package controller.hq.support;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dto.AccountDTO;
import dto.InquiryDTO;
import dto.InquiryReplyDTO;
import service.branch.InquiryService;
import service.branch.InquiryServiceImpl;
import util.GsonFactory;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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

@WebServlet("/hq/support/headquarters-inquiries-data")
public class HeadquartersInquiryController extends HttpServlet {

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
                int branchCode = 0; // 기본값은 전체 조회
                if (branchCodeStr != null && !branchCodeStr.equals("all")) {
                    try {
                        branchCode = Integer.parseInt(branchCodeStr);
                    } catch (NumberFormatException e) {
                        // branchCode가 숫자가 아닌 경우, 기본값 0 유지
                    }
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
            resp.getWriter().write("{\"message\": \"로그인이 필요합니다.\"}");
            return;
        }

        String action = req.getParameter("action");
        String requestBody = req.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
        String now = LocalDateTime.now().format(FORMATTER);

        try {
            if ("createReply".equals(action)) {
                JsonObject jsonObject = gson.fromJson(requestBody, JsonObject.class);
                int inquiryId = jsonObject.get("inquiryId").getAsInt();
                String content = jsonObject.get("content").getAsString();
                String newStatus = jsonObject.get("newStatus").getAsString();

                // 답변 전에 문의사항 조회 (어느 지점의 문의인지 알기 위해)
                InquiryDTO inquiry = inquiryService.getInquiryById(inquiryId);
                int targetBranchCode = (inquiry != null) ? inquiry.getBranchCode() : 0;

                InquiryReplyDTO newReply = new InquiryReplyDTO();
                newReply.setInquiryId(inquiryId);
                newReply.setContent(content);
                newReply.setAuthorId(loginUser.getAccountId());
                newReply.setCreatedAt(now);

                inquiryService.createReplyAndUpdateStatus(newReply, newStatus);

                // 문의사항을 작성한 지점에 알림 생성
                if (inquiry != null && targetBranchCode > 1) {  // 본사(branch_code=1) 제외
                    try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false)) {
                        Connection conn = sqlSession.getConnection();
                        String notifSql = "INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
                        try (PreparedStatement ps = conn.prepareStatement(notifSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                            ps.setString(1, "BOARD");
                            ps.setString(2, "문의사항 답변: " + inquiry.getTitle());
                            ps.setString(3, inquiry.getTitle() + " - " + now);
                            ps.setString(4, "INQUIRY");
                            ps.setNull(5, java.sql.Types.INTEGER);
                            ps.executeUpdate();

                            try (ResultSet keys = ps.getGeneratedKeys()) {
                                if (keys.next()) {
                                    int notifId = keys.getInt(1);
                                    String recvSql = "INSERT INTO notification_receiver (notification_id, account_id, is_read) SELECT ?, account_id, FALSE FROM account WHERE branch_code = ?";
                                    try (PreparedStatement ps2 = conn.prepareStatement(recvSql)) {
                                        ps2.setInt(1, notifId);
                                        ps2.setInt(2, targetBranchCode);
                                        ps2.executeUpdate();
                                    }
                                }
                            }
                            sqlSession.commit();
                        }
                    } catch (SQLException sqle) {
                        // 알림 실패는 로그만 남기고 답변은 정상 저장
                        sqle.printStackTrace();
                    }
                }

                resp.setStatus(HttpServletResponse.SC_CREATED);
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"message\": \"지원하지 않는 요청입니다.\"}");
            }
        } catch (Exception e) {
            handleException(resp, e);
        }
    }

    private void handleException(HttpServletResponse resp, Exception e) throws IOException {
        e.printStackTrace();
        resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        resp.getWriter().write("{\"message\": \"오류가 발생했습니다: " + e.getMessage() + "\"}");
    }
}