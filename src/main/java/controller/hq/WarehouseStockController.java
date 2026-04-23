package controller.hq;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.hq.warehouse.CategoryMaterialDTO;
import dto.hq.warehouse.WarehouseStockResultDTO;
import dto.hq.warehouse.WarehouseStockSearchDTO;
import service.hq.WarehouseStockService;
import service.hq.WarehouseStockServiceImpl;

@WebServlet("/hq/warehouse/stock")
public class WarehouseStockController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final WarehouseStockService service;
       
    public WarehouseStockController() {
        super();
        service = new WarehouseStockServiceImpl();
    }

    // /hq/warehouse_stock.jsp 화면을 초기에 띄울 때 호출된다.
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		//Map<String, List<String>> categoryMaterialMap = service.getCategoryMaterialMap();
		//request.setAttribute("categoryMaterialMap", categoryMaterialMap);
		//request.getRequestDispatcher("/hq/warehouse/stock.jsp").forward(request, response);
	}
}
