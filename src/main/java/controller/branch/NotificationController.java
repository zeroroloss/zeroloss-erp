package controller.branch;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.NotificationDTO;
import service.NotificationService;
import service.NotificationServiceImpl;

@WebServlet("/branch/common/notification")
public class NotificationController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private NotificationService notifService = new NotificationServiceImpl();
	
    public NotificationController() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session = request.getSession(false);
			if (session == null || session.getAttribute("accountId") == null) {
				response.sendRedirect(request.getContextPath() + "/login");
				return;
			}
			Integer accountId = (Integer) session.getAttribute("accountId");
			List<NotificationDTO> notifList = notifService.searchNotificationList(accountId);
			Integer totalNotif = notifService.selectNotifCnt(accountId);
			Integer isReadNotif = notifService.selectIsReadCnt(accountId);
			
			NotificationDTO notif = new NotificationDTO();
			notif.setAccountId(accountId);
			Integer todayNotif = notifService.selectTodayCnt(notif);
			
			request.setAttribute("notificationList", notifList);
			request.setAttribute("totalNotif", totalNotif);
			request.setAttribute("isReadNotif", isReadNotif);
			request.setAttribute("todayNotif", todayNotif);
			request.getRequestDispatcher("/branch/common/notification.jsp").forward(request, response);
		} catch(Exception e) {
			e.printStackTrace();
			request.setAttribute("errorMsg", e.getMessage());
			request.setAttribute("errorUrl", request.getRequestURI());
			request.getRequestDispatcher("/common/500.jsp").forward(request, response);
		}
	}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");

	    try {
	        HttpSession session = request.getSession(false);
	        if (session == null || session.getAttribute("accountId") == null) {
	            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	            response.getWriter().write("{\"success\":false,\"message\":\"로그인이 필요합니다.\"}");
	            return;
	        }
	        Integer accountId = (Integer) session.getAttribute("accountId");

	        String action = request.getParameter("action");

	        if (action == null || action.trim().isEmpty()) {
	            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	            response.getWriter().write("{\"success\":false,\"message\":\"action 값이 없습니다.\"}");
	            return;
	        }

	        if ("read".equals(action)) {
	            String id = request.getParameter("id");

	            if (id == null || id.trim().isEmpty()) {
	                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	                response.getWriter().write("{\"success\":false,\"message\":\"notification id가 없습니다.\"}");
	                return;
	            }

	            NotificationDTO notification = new NotificationDTO();
	            notification.setAccountId(accountId);
	            notification.setNotificationId(Integer.parseInt(id));

	            notifService.modifyIsRead(notification);

	            response.getWriter().write("{\"success\":true}");
	            return;
	        }

	        if ("readAll".equals(action)) {
	            notifService.modifyAllRead(accountId);

	            response.getWriter().write("{\"success\":true}");
	            return;
	        }

	        if ("delete".equals(action)) {
	            String id = request.getParameter("id");

	            if (id == null || id.trim().isEmpty()) {
	                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	                response.getWriter().write("{\"success\":false,\"message\":\"notification id가 없습니다.\"}");
	                return;
	            }

	            NotificationDTO notification = new NotificationDTO();
	            notification.setAccountId(accountId);
	            notification.setNotificationId(Integer.parseInt(id));

	            notifService.removeNotifReceiver(notification);

	            response.getWriter().write("{\"success\":true}");
	            return;
	        }

	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        response.getWriter().write("{\"success\":false,\"message\":\"지원하지 않는 action입니다.\"}");

	    } catch (Exception e) {
	        e.printStackTrace();
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        response.getWriter().write("{\"success\":false,\"message\":\"서버 오류가 발생했습니다.\"}");
	    }
	}
}
