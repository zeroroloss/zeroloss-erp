package controller.branch.place_order;

import java.io.IOException;
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
import service.branch.place_order.PlaceOrderService;
import service.branch.place_order.PlaceOrderServiceImpl;
import util.GsonFactory;

@WebServlet("/api/branch/place_order/create/items")
public class PlaceOrderCreateItemsApiController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final PlaceOrderService service = new PlaceOrderServiceImpl();
	private final Gson gson = GsonFactory.getGson();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");

		try {
			AccountDTO loginUser = getLoginUser(request);
			if (loginUser == null) {
				sendResponse(response, 401, failBody("로그인이 필요합니다."));
				return;
			}
			int branchCode = resolveBranchCode(loginUser);

			String category = request.getParameter("category");
			String item = request.getParameter("item");
			String search = request.getParameter("search");

			List<Map<String, Object>> filteredMaterials = service.getSelectableItems(branchCode, category, item, search);
			sendResponse(response, 200, successBody(filteredMaterials));

		} catch (Exception e) {
			e.printStackTrace();
			sendResponse(response, 500, errorBody(e.getMessage()));
		}
	}

	private int resolveBranchCode(AccountDTO loginUser) {
		if (loginUser == null) {
			return 1;
		}
		Integer branchCode = loginUser.getBranchCode();
		return branchCode != null ? branchCode : 1;
	}

	private boolean hasText(String value) {
		return value != null && !value.trim().isEmpty();
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

	private AccountDTO getLoginUser(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session == null) {
			return null;
		}
		return (AccountDTO) session.getAttribute("loginUser");
	}

	private void sendResponse(HttpServletResponse response, int status, Object body) throws IOException {
		response.setStatus(status);
		response.setContentType("application/json; charset=UTF-8");
		response.getWriter().write(gson.toJson(body));
	}
}

