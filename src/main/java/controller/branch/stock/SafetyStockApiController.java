package controller.branch.stock;

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
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import dto.AccountDTO;
import dto.branch.stock.BranchSafetyStockRowDTO;
import service.branch.stock.SafetyStockService;
import service.branch.stock.SafetyStockServiceImpl;
import util.GsonFactory;

@WebServlet("/api/branch/stock/safety_stock")
public class SafetyStockApiController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final SafetyStockService service = new SafetyStockServiceImpl();
	private final Gson gson = GsonFactory.getGson();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");
		try {
			AccountDTO loginUser = getLoginUser(request);
			if (loginUser == null) {
				response.setStatus(401);
				response.getWriter().write(gson.toJson(failBody("로그인이 필요합니다.")));
				return;
			}
			
			String categoryName = request.getParameter("category");
			String itemName = request.getParameter("item");
			
			// 지점코드, 카테고리명, 품목명에 해당되는 DB 데이터 가져오기
			List<BranchSafetyStockRowDTO> rows = service.selectSafetyStocks(resolveBranchCode(loginUser), categoryName, itemName);
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
			
			AccountDTO loginUser = getLoginUser(request);
			if (loginUser == null) {
				response.setStatus(401);
				response.getWriter().write(gson.toJson(failBody("로그인이 필요합니다.")));
				return;
			}
			
			Map<?, ?> body = gson.fromJson(request.getReader(), Map.class);
			
			String materialCode = body == null ? null : String.valueOf(body.get("materialCode"));
			BigDecimal safeStockQty = body == null || body.get("safeStockQty") == null ? null : new BigDecimal(String.valueOf(body.get("safeStockQty")));
			
			if (materialCode == null || materialCode.isBlank() || safeStockQty == null) {
				response.setStatus(400);
				response.getWriter().write(gson.toJson(failBody("필수값이 누락되었습니다.")));
				return;
			}
			
			// 지점코드, 품목번호에 해당하는 데이터 row의 안전재고를 safeStockQty로 업데이트
			int updated = service.updateSafetyStock(resolveBranchCode(loginUser), materialCode, safeStockQty);
			
			response.setStatus(updated > 0 ? 200 : 400);
			response.getWriter().write(gson.toJson(updated > 0 ? successBodyWithMessage("저장되었습니다.") : failBody("저장 실패")));
			
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(500);
			response.getWriter().write(gson.toJson(errorBody(e.getMessage())));
		}
	}

	private int resolveBranchCode(AccountDTO loginUser) {
		return (loginUser != null && loginUser.getBranchCode() != null)
				? loginUser.getBranchCode() 
				: 1;
	}

	private AccountDTO getLoginUser(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		return session == null ? null : (AccountDTO) session.getAttribute("loginUser");
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