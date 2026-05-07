package controller.branch.inbound;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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
import dto.branch.inbound.InboundHistoryDTO;
import service.branch.inbound.InboundHistoryService;
import service.branch.inbound.InboundHistoryServiceImpl;

@WebServlet("/api/branch/inbound/history")
public class InboundHistoryApiController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

	private final InboundHistoryService inboundHistoryService = new InboundHistoryServiceImpl();
	private final Gson gson = util.GsonFactory.getGson();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");

		try {
			AccountDTO loginUser = getLoginUser(request);
			String action = request.getParameter("action");
			String poNo = request.getParameter("poNo");

			if ("detail".equals(action) || hasText(poNo)) {
				if (!hasText(poNo)) {
					sendJson(response, HttpServletResponse.SC_BAD_REQUEST, failBody("poNo는 필수입니다."));
					return;
				}

				InboundHistoryDTO detail = inboundHistoryService.getInboundHistoryDetail(loginUser.getBranchCode(), poNo);
				if (detail == null) {
					sendJson(response, HttpServletResponse.SC_NOT_FOUND, failBody("입고 내역을 찾을 수 없습니다."));
					return;
				}

				sendJson(response, HttpServletResponse.SC_OK, successBody(detail));
				return;
			}

			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			if (!hasText(startDate) || !hasText(endDate)) {
				LocalDate today = LocalDate.now();
				startDate = hasText(startDate) ? startDate : today.withDayOfMonth(1).format(DATE_FORMATTER);
				endDate = hasText(endDate) ? endDate : today.withDayOfMonth(today.lengthOfMonth()).format(DATE_FORMATTER);
			}

			List<InboundHistoryDTO> historyList = inboundHistoryService.getInboundHistoryList(loginUser.getBranchCode(), startDate, endDate);
			sendJson(response, HttpServletResponse.SC_OK, successBody(historyList));
		} catch (Exception e) {
			e.printStackTrace();
			sendJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, failBody(e.getMessage()));
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

	private AccountDTO getLoginUser(HttpServletRequest request) {
		HttpSession session = request.getSession();
		AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");
		if (loginUser == null) {
			loginUser = new AccountDTO();
			loginUser.setAccountId(1);
			loginUser.setBranchCode(1);
		}
		return loginUser;
	}

	private boolean hasText(String value) {
		return value != null && !value.isBlank();
	}

	private void sendJson(HttpServletResponse response, int status, Map<String, Object> body) throws IOException {
		response.setStatus(status);
		response.getWriter().write(gson.toJson(body));
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
		body.put("message", message == null ? "요청 처리에 실패했습니다." : message);
		return body;
	}
}