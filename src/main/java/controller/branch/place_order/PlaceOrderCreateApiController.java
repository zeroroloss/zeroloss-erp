package controller.branch.place_order;

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

	private void sendResponse(HttpServletResponse response, int status, Object body) throws IOException {
		response.setStatus(status);
		response.getWriter().write(gson.toJson(body));
	}
}