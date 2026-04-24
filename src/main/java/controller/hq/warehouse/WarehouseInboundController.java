package controller.hq.warehouse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import service.hq.WarehouseStockService;
import service.hq.WarehouseStockServiceImpl;

@WebServlet("/hq/warehouse/inbound")
public class WarehouseInboundController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final WarehouseStockService service;
    private final Gson gson = new Gson();
	
	public WarehouseInboundController() {
        super();
        service = new WarehouseStockServiceImpl();
    }

	// 
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

		// List<Supplier>, List<MaterialGroup>, List<Material>을 페이지를 Get할 때 request를 통해 넘겨준다.
		List<String> supplierNameList = service.findSupplierNames();
		System.out.println("WarehouseInboundController doGet)" + "supplierNameList = " + supplierNameList);
		if (supplierNameList == null) supplierNameList = new ArrayList<>();
		
		Map<String, List<String>> categoryMaterialMap = service.getCategoryMaterialMap();
	    if (categoryMaterialMap == null) {
	        categoryMaterialMap = new LinkedHashMap<>();
	    }
	    System.out.println("WarehouseInboundController doGet)" + "categoryMaterialMap = " + categoryMaterialMap);
	    
	    request.setAttribute("supplierNameList", gson.toJson(supplierNameList));
	    request.setAttribute("categoryMaterialMap", gson.toJson(categoryMaterialMap));
		
		request.getRequestDispatcher("/hq/warehouse/inbound.jsp").forward(request, response);
	}

	// 신규 입고 등록 폼 POST 요청 시 호출된다.
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	}
	

     // 공통 JSON 응답 처리
    private void sendResponse(HttpServletResponse response, int status, Object body)
            throws IOException {

        response.setStatus(status);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(gson.toJson(body));
    }
}
