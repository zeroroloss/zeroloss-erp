package controller.branch.stock;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.AccountDTO;
import service.branch.stock.BranchStockAlertService;
import service.branch.stock.BranchStockAlertServiceImpl;

/**
 * Servlet implementation class StockAlertController
 */
@WebServlet("/branch/stock/alert")
public class StockAlertController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StockAlertController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 HttpSession session = request.getSession(false);
		try {
			// branchcode 가져오기
			AccountDTO loginUser = getLoginUser(request);
			if (loginUser == null) {
				response.setStatus(401); // 401 Unauthorized
				return;
			}
			int accountId  = (int) session.getAttribute("accountId");
			int branchCode = loginUser.getBranchCode();
			
			BranchStockAlertService branchStockAlertService = new BranchStockAlertServiceImpl();
			branchStockAlertService.sendStockAlerts(branchCode, accountId);

		} catch (Exception e) {
			e.printStackTrace();
		}
		response.sendRedirect(request.getContextPath() + "/branch/main/home");
	}
	
	
	private AccountDTO getLoginUser(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session == null)
			return null;
		return (AccountDTO) session.getAttribute("loginUser");
	}
}
