package controller.branch.place_order;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import dto.AccountDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.branch.place_order.PlaceOrderRequestDTO;
import service.branch.place_order.PlaceOrderService;
import service.branch.place_order.PlaceOrderServiceImpl;
import util.GsonFactory;

@WebServlet("/api/branch/place_order")
public class PlaceOrderHistoryApiController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static final int DEFAULT_BRANCH_CODE = 1;

	private static final String ACTION_DETAIL = "detail";
	private static final String ACTION_CANCEL = "cancel";
	private static final String ACTION_SUBMIT = "submit";

	private static final String STATUS_REJECTED = "REJECTED";
	private static final String RESPONSE_STATUS = "status";
	private static final String RESPONSE_MESSAGE = "message";
	private static final String RESPONSE_DATA = "data";
	private static final String STATUS_SUCCESS = "success";
	private static final String STATUS_FAIL = "fail";
	private static final String STATUS_ERROR = "error";

	private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

	private final PlaceOrderService placeOrderService = new PlaceOrderServiceImpl();
	private final Gson gson = GsonFactory.getGson();

	// 특정 발주 {poNo}의 발주 품목 상세
	// "/api/branch/place_order?action=...&poNo=...&startDate=...&endDate=...&status=..."
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");

		try {
			AccountDTO loginUser = getLoginUser(request);
			if (loginUser == null) {
				sendResponse(response, 401, failBody("로그인이 필요합니다."));
				return;
			}

			String action = request.getParameter("action");
			String poNo = request.getParameter("poNo");

			// ~_detail.jsp 상세 조회
			if (ACTION_DETAIL.equals(action) || hasText(poNo)) {
				if (!hasText(poNo)) {
					sendResponse(response, 400, failBody("poNo는 필수입니다."));
					return;
				}

				PlaceOrderHistoryDTO detail = placeOrderService.getPlaceOrderDetail(poNo);
				if (detail == null) {
					sendResponse(response, 404, failBody("발주서를 찾을 수 없습니다."));
					return;
				}

				sendResponse(response, 200, successBody(detail));
				return;
			}

			// history.jsp 조회하기
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			if (!hasText(startDate) || !hasText(endDate)) {
				LocalDate today = LocalDate.now();
				LocalDate monthStart = today.withDayOfMonth(1);
				LocalDate monthEnd = today.withDayOfMonth(today.lengthOfMonth());
				startDate = hasText(startDate) ? startDate : monthStart.format(DATE_FORMATTER);
				endDate = hasText(endDate) ? endDate : monthEnd.format(DATE_FORMATTER);
			}

			List<PlaceOrderHistoryDTO> historyList = placeOrderService.getPlaceOrderHistoryList(
					resolveBranchCode(loginUser), startDate, endDate, request.getParameter("status"));
			sendResponse(response, 200, successBody(historyList));

		} catch (Exception e) {
			e.printStackTrace();
			sendResponse(response, 500, errorBody(e.getMessage()));
		}
	}

	// 발주서 작성
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");

		AccountDTO loginUser = getLoginUser(request);
		if (loginUser == null) {
			sendResponse(response, 401, failBody("로그인이 필요합니다."));
			return;
		}

		String action = hasText(request.getParameter("action")) ? request.getParameter("action") : ACTION_SUBMIT;

		try {
			if (ACTION_CANCEL.equals(action)) {
				String poNo = request.getParameter("poNo");
				String rejectReason = request.getParameter("rejectReason");
				boolean ok = placeOrderService.updatePlaceOrderStatus(poNo, STATUS_REJECTED, rejectReason);
				sendResponse(response, ok ? 200 : 400,
						ok ? successBodyWithMessage("취소 요청이 처리되었습니다.") : failBody("취소 요청 실패"));
				return;
			}

			String requestBody = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
			PlaceOrderRequestDTO placeOrderRequestDTO = gson.fromJson(requestBody, PlaceOrderRequestDTO.class);
			if (placeOrderRequestDTO.getBranchCode() == null) {
				placeOrderRequestDTO.setBranchCode(resolveBranchCode(loginUser));
			}

			// 발주 생성
			boolean ok = placeOrderService.createPlaceOrder(placeOrderRequestDTO);
			sendResponse(response, ok ? 200 : 400, ok ? successBodyWithMessage("발주가 저장되었습니다.") : failBody("발주 저장 실패"));

		} catch (Exception e) {
			e.printStackTrace();
			sendResponse(response, 500, errorBody(e.getMessage()));
		}
	}

	private int resolveBranchCode(AccountDTO loginUser) {
		if (loginUser == null || loginUser.getBranchCode() == null) {
			return DEFAULT_BRANCH_CODE;
		}
		return loginUser.getBranchCode();
	}

	private boolean hasText(String value) {
		return value != null && !value.isBlank();
	}

	private Map<String, Object> successBody(Object data) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put(RESPONSE_STATUS, STATUS_SUCCESS);
		body.put(RESPONSE_DATA, data);
		return body;
	}

	private Map<String, Object> successBodyWithMessage(String message) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put(RESPONSE_STATUS, STATUS_SUCCESS);
		body.put(RESPONSE_MESSAGE, message);
		return body;
	}

	private Map<String, Object> failBody(String message) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put(RESPONSE_STATUS, STATUS_FAIL);
		body.put(RESPONSE_MESSAGE, message);
		return body;
	}

	private Map<String, Object> errorBody(String message) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put(RESPONSE_STATUS, STATUS_ERROR);
		body.put(RESPONSE_MESSAGE, hasText(message) ? message : "서버 처리 중 오류가 발생했습니다.");
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