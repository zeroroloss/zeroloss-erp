package controller.hq.place_order;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dto.hq.place_order.PlaceOrderProcessingDTO;
import dto.hq.place_order.PlaceOrderProcessingDetailDTO;
import service.hq.place_order.PlaceOrderProcessingService;
import service.hq.place_order.PlaceOrderProcessingServiceImpl;
import util.GsonFactory;

@WebServlet("/hq/place_order/processing")
public class PlaceOrderProcessingController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String ACTION_LIST = "list";
	private static final String ACTION_DETAIL = "detail";
	private static final String ACTION_APPROVE = "approve";
	private static final String ACTION_REJECT = "reject";

	private final PlaceOrderProcessingService service = new PlaceOrderProcessingServiceImpl();
	private final Gson gson = GsonFactory.getGson();
       
    public PlaceOrderProcessingController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");

		if (ACTION_LIST.equals(action)) {
			writeJson(response, 200, successBody(service.getPendingOrders()));
			return;
		}

		if (ACTION_DETAIL.equals(action)) {
			String poNo = request.getParameter("poNo");
			PlaceOrderProcessingDTO detail = service.getOrderDetail(poNo);
			writeJson(response, 200, successBody(detail));
			return;
		}

		request.getRequestDispatcher("/hq/place_order/processing.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<?, ?> body = gson.fromJson(request.getReader(), Map.class);
		String action = valueAsString(body == null ? null : body.get("action"));

		if (ACTION_APPROVE.equals(action)) {
			String poNo = valueAsString(body.get("poNo"));
			List<PlaceOrderProcessingDetailDTO> details = PlaceOrderProcessingDetailDTO.from(body.get("details"));
			boolean updated = service.approveOrder(poNo, details);
			writeJson(response, updated ? 200 : 400, updated ? successBodyWithMessage("승인되었습니다.") : failBody("승인 처리에 실패했습니다."));
			return;
		}

		if (ACTION_REJECT.equals(action)) {
			String poNo = valueAsString(body.get("poNo"));
			String rejectReason = valueAsString(body.get("rejectReason"));
			boolean updated = service.rejectOrder(poNo, rejectReason);
			writeJson(response, updated ? 200 : 400, updated ? successBodyWithMessage("반려되었습니다.") : failBody("반려 처리에 실패했습니다."));
			return;
		}

		writeJson(response, 400, failBody("지원하지 않는 요청입니다."));
	}

	private String valueAsString(Object value) {
		return value == null ? null : String.valueOf(value);
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

	private void writeJson(HttpServletResponse response, int status, Object payload) throws IOException {
		response.setStatus(status);
		response.setContentType("application/json; charset=UTF-8");
		response.getWriter().write(gson.toJson(payload));
	}

}
