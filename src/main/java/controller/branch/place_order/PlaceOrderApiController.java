package controller.branch.place_order;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
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
public class PlaceOrderApiController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private final PlaceOrderService placeOrderService = new PlaceOrderServiceImpl();
    private final Gson gson = GsonFactory.getGson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

        try {
            AccountDTO loginUser = getLoginUser(request);
            String action = request.getParameter("action");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String status = request.getParameter("status");

            if (startDate == null || startDate.isBlank() || endDate == null || endDate.isBlank()) {
                LocalDate today = LocalDate.now();
                LocalDate monthStart = today.withDayOfMonth(1);
                LocalDate monthEnd = today.withDayOfMonth(today.lengthOfMonth());

                if (startDate == null || startDate.isBlank()) {
                    startDate = monthStart.format(DATE_FORMATTER);
                }
                if (endDate == null || endDate.isBlank()) {
                    endDate = monthEnd.format(DATE_FORMATTER);
                }
            }

            if ("detail".equals(action) || request.getParameter("poNo") != null) {
                String poNo = request.getParameter("poNo");
                PlaceOrderHistoryDTO detail = placeOrderService.getPlaceOrderDetail(poNo);
                sendResponse(response, 200, Map.of(
                        "status", "success",
                        "data", detail
                ));
                return;
            }

            List<PlaceOrderHistoryDTO> historyList = placeOrderService.getPlaceOrderHistory(
                    loginUser.getBranchCode() != null ? loginUser.getBranchCode() : 1,
                    startDate,
                    endDate,
                    status
            );

            sendResponse(response, 200, Map.of(
                    "status", "success",
                    "data", historyList
            ));

        } catch (Exception e) {
            e.printStackTrace();
            sendResponse(response, 500, Map.of(
                    "status", "error",
                    "message", e.getMessage()
            ));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "submit";
        }

        try {
            if ("cancel".equals(action)) {
                String poNo = request.getParameter("poNo");
                String rejectReason = request.getParameter("rejectReason");
                boolean ok = placeOrderService.updatePlaceOrderStatus(poNo, "REJECTED", rejectReason);
                sendResponse(response, ok ? 200 : 400, Map.of(
                        "status", ok ? "success" : "fail",
                        "message", ok ? "취소 요청이 처리되었습니다." : "취소 요청 실패"
                ));
                return;
            }

            String requestBody = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
            PlaceOrderRequestDTO placeOrderRequestDTO = gson.fromJson(requestBody, PlaceOrderRequestDTO.class);
            AccountDTO loginUser = getLoginUser(request);
            if (placeOrderRequestDTO.getBranchCode() == null) {
                placeOrderRequestDTO.setBranchCode(loginUser.getBranchCode() != null ? loginUser.getBranchCode() : 1);
            }

            boolean ok = placeOrderService.createPlaceOrder(placeOrderRequestDTO);
            sendResponse(response, ok ? 200 : 400, Map.of(
                    "status", ok ? "success" : "fail",
                    "message", ok ? "발주가 저장되었습니다." : "발주 저장 실패"
            ));

        } catch (Exception e) {
            e.printStackTrace();
            sendResponse(response, 500, Map.of(
                    "status", "error",
                    "message", e.getMessage()
            ));
        }
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

    private void sendResponse(HttpServletResponse response, int status, Object body) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(gson.toJson(body));
    }
}