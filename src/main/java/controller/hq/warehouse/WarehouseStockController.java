package controller.hq.warehouse;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.hq.warehouse.WarehouseStockService;
import service.hq.warehouse.WarehouseStockServiceImpl;


@WebServlet("/hq/warehouse/stock")
public class WarehouseStockController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final WarehouseStockService service = new WarehouseStockServiceImpl();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	    Map<String, List<String>> categoryMaterialMap = service.getCategoryMaterialMap();
	    if (categoryMaterialMap == null) {
	        categoryMaterialMap = new LinkedHashMap<>();
	    }
	    
	    request.setAttribute("categoryMaterialMap", categoryMaterialMap);
	    request.getRequestDispatcher("/hq/warehouse/stock.jsp").forward(request, response);
	}
}
