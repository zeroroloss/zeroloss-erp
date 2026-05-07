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

import com.google.gson.Gson;

import dto.MaterialDTO;
import service.branch.stock.BranchStockService;
import service.branch.stock.BranchStockServiceImpl;

@WebServlet("/branch/stock/materials")
public class StockMaterialController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json;charset=UTF-8");

		try {
			Map<String, Object> params = new HashMap<>();
			params.put("materialGroupId", request.getParameter("materialGroupId"));

			BranchStockService branchStockService = new BranchStockServiceImpl();
			List<MaterialDTO> list = branchStockService.selectMaterialListByCategory(params);
			response.getWriter().write(new Gson().toJson(list));
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\":\"서버 오류가 발생했습니다.\"}");
		}
	}
}
