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


/**
 * 유통기한 조회 페이지 요청 처리
 * GET /hq/warehouse/expiry_date
 */
@WebServlet("/hq/warehouse/expiry_date")
public class WarehouseExpiryDateController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final WarehouseStockService service;
	
	public WarehouseExpiryDateController() {
        super();
        service = new WarehouseStockServiceImpl();
    }

	@Override 
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		
		try {
			Map<String, List<String>> categoryMaterialMap = service.getCategoryMaterialMap();
		    if (categoryMaterialMap == null) {
		        categoryMaterialMap = new LinkedHashMap<>();
		    }
		    request.setAttribute("categoryMaterialMap", categoryMaterialMap);
			request.getRequestDispatcher("/hq/warehouse/expiry_date.jsp").forward(request, response);
		    
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "데이터 로드 중 오류가 발생했습니다: " + e.getMessage());
			request.getRequestDispatcher("/hq/warehouse/expiry_date.jsp").forward(request, response);
		}
	}
}
