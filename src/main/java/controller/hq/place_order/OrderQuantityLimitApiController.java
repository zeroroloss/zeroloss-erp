package controller.hq.place_order;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dto.hq.place_order.OrderQuantityLimitDTO;
import service.hq.place_order.OrderQuantityLimitService;
import service.hq.place_order.OrderQuantityLimitServiceImpl;
import util.GsonFactory;

@WebServlet("/api/hq/place_order/order_quantity_limit")
public class OrderQuantityLimitApiController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final OrderQuantityLimitService service = new OrderQuantityLimitServiceImpl(); 
	private final Gson gson = GsonFactory.getGson();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");
		
		try {
			String categoryName = request.getParameter("category");
			String itemName = request.getParameter("item");
			List<OrderQuantityLimitDTO> rows = service.selectLimits(categoryName, itemName);
			
			response.getWriter().write(gson.toJson(successBody(rows)));
			
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(500);
			response.getWriter().write(gson.toJson(errorBody(e.getMessage())));
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");
		
		try {
			// JSON 요청 데이터를 Map으로 파싱 (타입 미정)
			Map<?, ?> body = gson.fromJson(request.getReader(), Map.class);
			
			String materialCode = body == null ? null : String.valueOf(body.get("materialCode"));
			BigDecimal minQty = body == null || body.get("minQty") == null ? null : new BigDecimal(String.valueOf(body.get("minQty")));
			BigDecimal maxQty = body == null || body.get("maxQty") == null ? null : new BigDecimal(String.valueOf(body.get("maxQty")));
			
			if (materialCode == null || materialCode.isBlank() || minQty == null || maxQty == null) {
				// 400 에러 (Bad Request)
				response.setStatus(400);
				response.getWriter().write(gson.toJson(failBody("필수값이 누락되었습니다.")));
				return;
			}
			
			int updated = service.updateLimit(materialCode, minQty, maxQty);
			response.setStatus(updated > 0 ? 200 : 400);
			response.getWriter().write(gson.toJson(updated > 0 ? successBodyWithMessage("저장되었습니다.") : failBody("저장 실패")));
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(500);
			response.getWriter().write(gson.toJson(errorBody(e.getMessage())));
		}
	}

	private Map<String, Object> successBody(Object data) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put("status", "success");
		body.put("data", data);
		return body;
	}

	private Map<String, Object> successBodyWithMessage(String message) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put("status", "success");
		body.put("message", message);
		return body;
	}

	private Map<String, Object> failBody(String message) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put("status", "fail");
		body.put("message", message);
		return body;
	}

	private Map<String, Object> errorBody(String message) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put("status", "error");
		body.put("message", message == null || message.isBlank() ? "서버 처리 중 오류가 발생했습니다." : message);
		return body;
	}
}