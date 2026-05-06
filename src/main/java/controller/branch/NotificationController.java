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
import service.AccountService;
import service.AccountServiceImpl;
import service.NotificationService;
import service.NotificationServiceImpl;

/**
 * Servlet implementation class NotificationController
 */
@WebServlet("/branch/common/notification")
public class NotificationController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private NotificationService notifService = new NotificationServiceImpl();
    private AccountService accService = new AccountServiceImpl();  
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NotificationController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session = request.getSession(false);
			
			if(session == null || session.getAttribute("accountId")== null) {
				response.sendRedirect(request.getContextPath() + "/common/login.jsp");
				return;
			}
			
			Integer accountId = (Integer) session.getAttribute("accountId");
			
			NotificationDTO notif = new NotificationDTO();
			notif.setAccountId(accountId);
			List<NotificationDTO> notifList = notifService.searchNotificationList(accountId);
			Integer totalNotif = notifService.selectNotifCnt(accountId);
			Integer isReadNotif = notifService.selectIsReadCnt(accountId);
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
