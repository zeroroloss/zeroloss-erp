package controller.common;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.AccountDTO;
import service.AccountService;
import service.AccountServiceImpl;

/**
 * Servlet implementation class Login
 */
@WebServlet("/login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Login() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/common/login.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		String contextPath = request.getContextPath();
		String loginId = request.getParameter("loginId");
		String password = request.getParameter("password");
		
		try {
			AccountService service = new AccountServiceImpl();
			AccountDTO account = service.login(loginId, password);
			
			HttpSession session = request.getSession();
			session.setAttribute("loginUser", account);
			session.setAttribute("roleName", account.getRoleName());
			session.setAttribute("branchCode", account.getBranchCode());
			session.setAttribute("branchName", account.getBranchName());
			session.setAttribute("userName", account.getUserName());
			
			if(account.getHqId()!= null) {
				response.sendRedirect(request.getContextPath()+"/hq/main/home");
			} else if(account.getBranchCode() != null) {
				response.sendRedirect(request.getContextPath()+"/branch/main/home.jsp");
			} else {
				throw new Exception("계정 소속 정보가 올바르지 않습니다.");
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			request.setAttribute("error", e.getMessage());
			request.getRequestDispatcher("/common/login.jsp").forward(request, response);
		}
	}

}
