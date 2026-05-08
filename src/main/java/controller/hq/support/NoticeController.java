package controller.hq.support;

import com.google.gson.Gson;
import dto.NoticeDTO;
import service.hq.NoticeService;
import service.hq.NoticeServiceImpl;
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
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/hq/support/headquarters-notices-data")
public class NoticeController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final NoticeService noticeService = new NoticeServiceImpl();
    private final Gson gson = GsonFactory.getGson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            List<NoticeDTO> notices = noticeService.getNotices();
            resp.getWriter().write(gson.toJson(notices));
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if (action == null) action = "create";

        try {
            // [1] 조회수 증가
            if ("view".equals(action)) {
                int noticeId = Integer.parseInt(req.getParameter("id"));
                noticeService.incrementViewCount(noticeId);
                resp.setStatus(HttpServletResponse.SC_OK);
                return;
            }
            // [2] 삭제
            else if ("delete".equals(action)) {
                int noticeId = Integer.parseInt(req.getParameter("id"));
                noticeService.deleteNotice(noticeId);
                resp.setStatus(HttpServletResponse.SC_OK);
                return;
            }

            // [3] 작성 & 수정 (JSON Body 파싱)
            String requestBody = req.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
            NoticeDTO noticeDTO = gson.fromJson(requestBody, NoticeDTO.class);

            // 현재 로그인된 유저라 가정 (본인 확인용)
            noticeDTO.setAuthorId(1);

            // 🟢 현재 시간을 애플리케이션 레벨에서 설정
            String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss"));

            if ("update".equals(action)) {
                noticeDTO.setLastDate(now);
                noticeService.updateNotice(noticeDTO);

                // 알림 생성: 본사 제외 모든 지점 계정에 알림 전송
                try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false)) {
                    Connection conn = sqlSession.getConnection();
                    String notifSql = "INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
                    try (PreparedStatement ps = conn.prepareStatement(notifSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                        ps.setString(1, "BOARD");
                        ps.setString(2, "공지사항 수정: " + noticeDTO.getTitle());
                        ps.setString(3, noticeDTO.getTitle() + " - " + (noticeDTO.getLastDate() != null ? noticeDTO.getLastDate() : now));
                        ps.setString(4, "NOTICE");
                        ps.setNull(5, java.sql.Types.INTEGER);
                        ps.executeUpdate();
                        try (ResultSet keys = ps.getGeneratedKeys()) {
                            if (keys.next()) {
                                int notifId = keys.getInt(1);
                                String recvSql = "INSERT INTO notification_receiver (notification_id, account_id, is_read) SELECT ?, account_id, FALSE FROM account WHERE branch_code <> 1";
                                try (PreparedStatement ps2 = conn.prepareStatement(recvSql)) {
                                    ps2.setInt(1, notifId);
                                    ps2.executeUpdate();
                                }
                            }
                        }
                        sqlSession.commit();
                    }
                } catch (SQLException sqle) {
                    // 알림 실패는 로그만 남기고 진행
                    sqle.printStackTrace();
                }

            } else {
                noticeDTO.setCreatedAt(now);
                noticeDTO.setLastDate(now);
                noticeService.createNotice(noticeDTO);

                // 알림 생성: 본사 제외 모든 지점 계정에 알림 전송
                try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false)) {
                    Connection conn = sqlSession.getConnection();
                    String notifSql = "INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
                    try (PreparedStatement ps = conn.prepareStatement(notifSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    	
                        String title = "[공지사항] " + noticeDTO.getTitle();
                        String message = "["+ noticeDTO.getType() +"] " + noticeDTO.getContent();

                        ps.setString(1, "BOARD");
                        ps.setString(2, title);
                        ps.setString(3, message);
                        ps.setString(4, "NOTICE");
                        ps.setInt(5, noticeDTO.getNoticeId());
                        ps.executeUpdate();
                        try (ResultSet keys = ps.getGeneratedKeys()) {
                            if (keys.next()) {
                                int notifId = keys.getInt(1);
                                String recvSql = "INSERT INTO notification_receiver (notification_id, account_id, is_read) SELECT ?, account_id, FALSE FROM account WHERE branch_code <> 1";
                                try (PreparedStatement ps2 = conn.prepareStatement(recvSql)) {
                                    ps2.setInt(1, notifId);
                                    ps2.executeUpdate();
                                }
                            }
                        }
                        sqlSession.commit();
                    }
                } catch (SQLException sqle) {
                    // 알림 실패는 로그만 남기고 진행
                    sqle.printStackTrace();
                }
            }

            resp.setStatus(HttpServletResponse.SC_OK);

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
    }
}