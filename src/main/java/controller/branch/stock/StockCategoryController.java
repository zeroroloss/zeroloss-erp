package controller.branch.stock;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import dto.AccountDTO;
import dto.MaterialDTO;
import dto.MaterialGroupDTO;
import service.BranchService;
import service.BranchServiceImpl;
import service.branch.stock.BranchStockService;
import service.branch.stock.BranchStockServiceImpl;

/**
 * Servlet implementation class StockCategoryController
 */
@WebServlet("/branch/stock/categories")
public class StockCategoryController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public StockCategoryController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json;charset=UTF-8");

		try {
			AccountDTO loginUser = getLoginUser(request);
	         if (loginUser == null) {
	            response.setStatus(401); // 401 Unauthorized
	            return;
	         }
	         
	         int branchCode = loginUser.getBranchCode();
			BranchStockService branchStockService = new BranchStockServiceImpl();
			List<MaterialGroupDTO> list = branchStockService.selectCategoryList(branchCode);
			response.getWriter().write(new Gson().toJson(list));
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\":\"서버 오류가 발생했습니다.\"}");
		}
	}
	
	private AccountDTO getLoginUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (AccountDTO) session.getAttribute("loginUser");
    }
}
