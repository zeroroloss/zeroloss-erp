package controller.branch.stock;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
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
import com.google.gson.GsonBuilder;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;

import dto.AccountDTO;
import dto.BranchStockDTO;
import service.branch.stock.BranchStockService;
import service.branch.stock.BranchStockServiceImpl;

/**
 * Servlet implementation class StockStatusController
 */
@WebServlet("/branch/stock/status")
public class StockStatusController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public StockStatusController() {
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
			// branchcode 가져오기
			AccountDTO loginUser = getLoginUser(request);
			if (loginUser == null) {
				response.setStatus(401); // 401 Unauthorized
				return;
			}

			int branchCode = loginUser.getBranchCode();

			// 페이징 처리
			int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
			int pageSize = 10;
			int offset = (page - 1) * pageSize;

			Map<String, Object> params = new HashMap<>();
			params.put("branchCode", branchCode);
			params.put("materialGroupId", request.getParameter("materialGroupId"));
			params.put("materialName", request.getParameter("materialName"));
			params.put("keyword", request.getParameter("keyword"));
			params.put("pageSize", pageSize);
			params.put("offset", offset);
			params.put("sortField", request.getParameter("sortField"));
			params.put("sortDir",   request.getParameter("sortDir"));

			BranchStockService branchStockService = new BranchStockServiceImpl();

			int totalCount = branchStockService.selectBranchStockCount(params);
			List<BranchStockDTO> list = branchStockService.selectBranchStockList(params);

			Map<String, Object> result = new HashMap<>();
			result.put("list", list);
			result.put("totalCount", totalCount);
			result.put("page", page);
			result.put("pageSize", pageSize);
			result.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));

			Gson gson = new GsonBuilder()
					.registerTypeAdapter(LocalDate.class,
							(JsonSerializer<LocalDate>) (src, type, ctx) -> new JsonPrimitive(src.toString()))
					.registerTypeAdapter(LocalDateTime.class,
							(JsonSerializer<LocalDateTime>) (src, type, ctx) -> new JsonPrimitive(
									src.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))))
					.registerTypeAdapter(BigDecimal.class,
							(JsonSerializer<BigDecimal>) (src, type, ctx) -> new JsonPrimitive(src.toPlainString()))
					.create();
			response.getWriter().write(gson.toJson(result));
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\":\"서버 오류가 발생했습니다.\"}");
		}
	}

	private AccountDTO getLoginUser(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session == null)
			return null;
		return (AccountDTO) session.getAttribute("loginUser");
	}

}
