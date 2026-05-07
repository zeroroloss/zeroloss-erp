package controller.hq.warehouse;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.reflect.TypeToken;

import dto.hq.warehouse.InboundRequestDTO;
import service.hq.warehouse.WarehouseStockService;
import service.hq.warehouse.WarehouseStockServiceImpl;
import util.GsonFactory;

@WebServlet("/hq/warehouse/inbound")
public class WarehouseInboundController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final WarehouseStockService service = new WarehouseStockServiceImpl();

	@Override 
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		// List<Supplier>, List<MaterialGroup>, List<Material>을 페이지를 Get할 때 request를 통해 넘겨준다.
		List<String> supplierNameList = service.findSupplierNames();
		System.out.println("WarehouseInboundController doGet)" + "supplierNameList = " + supplierNameList);
		if (supplierNameList == null) supplierNameList = new ArrayList<>();
		
		//
		Map<String, List<String>> categoryMaterialMap = service.getCategoryMaterialMap();
	    if (categoryMaterialMap == null) categoryMaterialMap = new LinkedHashMap<>();
	    System.out.println("WarehouseInboundController doGet)" + "categoryMaterialMap = " + categoryMaterialMap);
	    
	    // 
	    Map<String, Integer> materialPriceMap = service.getMaterialPriceMap();
	    if (materialPriceMap == null) materialPriceMap = new LinkedHashMap<>(); 
	    System.out.println("materialPriceMap = " + materialPriceMap);

	    
	    request.setAttribute("supplierNameList", supplierNameList);
	    request.setAttribute("categoryMaterialMap", categoryMaterialMap);
	    request.setAttribute("materialPriceMap", materialPriceMap);
		
		request.getRequestDispatcher("/hq/warehouse/inbound.jsp").forward(request, response);
	}

	// 신규 입고 등록 폼 POST 요청 시 호출된다.
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			Type type = new TypeToken<Map<String, Object>>() {}.getType();
			Map<String, Object> body = GsonFactory.getGson().fromJson(req.getReader(), type);
            String supplier = (String)body.get("supplier");
            String category = (String)body.get("category");
            String itemName = (String)body.get("itemName");
            String quantity = (String)body.get("quantity");
            
            InboundRequestDTO inboundReqDTO = new InboundRequestDTO();
            inboundReqDTO.setSupplier(supplier);
            inboundReqDTO.setCategory(category);
            inboundReqDTO.setItemName(itemName);
            inboundReqDTO.setQuantity(Integer.parseInt(quantity));
            //inboundReqDTO.setUnitPrice(unitPrice);
            
            sendResponse(resp, 200, Map.of(
                    "status", "success",
                    "message", "입고 등록 완료"
            ));

        } catch (Exception e) {
            sendResponse(resp, 500, Map.of(
                "status", "error",
                "message", e.getMessage()
            ));
        }
	}
	
     // 공통 JSON 응답 처리
    private void sendResponse(HttpServletResponse response, int status, Object body)
            throws IOException {

        response.setStatus(status);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(GsonFactory.getGson().toJson(body));
    }
}
