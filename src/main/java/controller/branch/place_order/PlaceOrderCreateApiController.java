package controller.branch.place_order;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import dto.AccountDTO;
import dto.branch.place_order.PlaceOrderDraftDetailDTO;
import dto.branch.place_order.PlaceOrderDraftDTO;
import service.branch.place_order.PlaceOrderService;
import service.branch.place_order.PlaceOrderServiceImpl;
import util.GsonFactory;

@WebServlet("/api/branch/place_order/create")
public class PlaceOrderCreateApiController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final PlaceOrderService service = new PlaceOrderServiceImpl();
	private final Gson gson = GsonFactory.getGson();

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");

		try {
			AccountDTO loginUser = getLoginUser(request);
			if (loginUser == null) {
				sendResponse(response, 401, failBody("로그인이 필요합니다."));
				return;
			}

			PlaceOrderDraftDTO draft = service.findOrCreateInProgressDraft(loginUser.getBranchCode());
			sendResponse(response, 200, successBody(draft));
		} catch (Exception e) {
			e.printStackTrace();
			sendResponse(response, 500, errorBody(e.getMessage()));
		}
	}
    
	// 발주서 작성 페이지에서 - 발주 대상 품목 리스트에 추가/제외 시마다 호출된다.
	// DB place_order_draft_detail 테이블에 INSERT or DELETE
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("application/json; charset=UTF-8");
		resp.setCharacterEncoding("UTF-8");

		try {
			AccountDTO loginUser = getLoginUser(req);
			if (loginUser == null) {
				sendResponse(resp, 401, failBody("로그인이 필요합니다."));
				return;
			}

			Map<String, Object> payload = readBody(req);
			String action = payload != null ? stringValue(payload.get("action")) : null;
			Map<String, Object> itemMap = payload != null ? castMap(payload.get("item")) : null;
			if (!hasText(action) || itemMap == null || !hasText(stringValue(itemMap.get("materialCode")))) {
				sendResponse(resp, 400, failBody("요청 데이터가 올바르지 않습니다."));
				return;
			}

			PlaceOrderDraftDetailDTO detailDTO = new PlaceOrderDraftDetailDTO();
			detailDTO.setMaterialCode(stringValue(itemMap.get("materialCode")));
			detailDTO.setMaterialName(stringValue(itemMap.get("materialName")));
			detailDTO.setCategoryName(stringValue(itemMap.get("categoryName")));
			detailDTO.setUnit(stringValue(itemMap.get("unit")));
			detailDTO.setSourceType(stringValue(itemMap.get("sourceType")));
			detailDTO.setCurrentStock(toInteger(itemMap.get("currentStock")));
			detailDTO.setSafeStock(toInteger(itemMap.get("safeStock")));
			detailDTO.setRequestedQty(toInteger(itemMap.get("requestedQty")));

			boolean saved = service.updatePlaceOrderDraftDetail(loginUser.getBranchCode(), action, detailDTO);
			if (!saved) {
				sendResponse(resp, 500, errorBody("발주 임시저장 반영에 실패했습니다."));
				return;
			}

			sendResponse(resp, 200, successBody(null));
		} catch (Exception e) {
			e.printStackTrace();
			sendResponse(resp, 500, errorBody(e.getMessage()));
		}
	}


	//========

	private AccountDTO getLoginUser(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session == null) {
			return null;
		}
		return (AccountDTO) session.getAttribute("loginUser");
	}

	private Map<String, Object> successBody(Object data) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put("status", "success");
		body.put("data", data);
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
		body.put("message", hasText(message) ? message : "서버 처리 중 오류가 발생했습니다.");
		return body;
	}

	private boolean hasText(String value) {
		return value != null && !value.trim().isEmpty();
	}

	private Map<String, Object> readBody(HttpServletRequest request) throws IOException {
		StringBuilder body = new StringBuilder();
		try (BufferedReader reader = request.getReader()) {
			String line;
			while ((line = reader.readLine()) != null) {
				body.append(line);
			}
		}
		if (!hasText(body.toString())) {
			return null;
		}
		return gson.fromJson(body.toString(), Map.class);
	}

	@SuppressWarnings("unchecked")
	private Map<String, Object> castMap(Object value) {
		if (value instanceof Map) {
			return (Map<String, Object>) value;
		}
		return null;
	}

	private String stringValue(Object value) {
		return value == null ? null : String.valueOf(value);
	}

	private Integer toInteger(Object value) {
		if (value == null) {
			return null;
		}
		if (value instanceof Number) {
			return ((Number) value).intValue();
		}
		try {
			String text = String.valueOf(value).trim();
			if (!hasText(text)) {
				return null;
			}
			return (int) Math.round(Double.parseDouble(text));
		} catch (Exception e) {
			return null;
		}
	}

	private void sendResponse(HttpServletResponse response, int status, Object body) throws IOException {
		response.setStatus(status);
		response.getWriter().write(gson.toJson(body));
	}
}