package controller.hq.support;

import com.google.gson.Gson;
import dto.NoticeDTO;
import service.hq.NoticeService;
import service.hq.NoticeServiceImpl;
import util.GsonFactory;

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
            } else {
                noticeDTO.setCreatedAt(now);
                noticeDTO.setLastDate(now);
                noticeService.createNotice(noticeDTO);
            }

            resp.setStatus(HttpServletResponse.SC_OK);

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
    }
}