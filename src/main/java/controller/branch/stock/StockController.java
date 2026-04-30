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

import dto.BranchStockDTO;
import service.branch.stock.BranchStockService;
import service.branch.stock.BranchStockServiceImpl;

@WebServlet("/branch/stock")
public class StockController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public StockController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		 request.getRequestDispatcher("/branch/stock/stock.jsp")
         .forward(request, response);
	}
}
