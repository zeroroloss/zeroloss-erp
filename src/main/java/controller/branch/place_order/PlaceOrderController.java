package controller.branch.place_order;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.AccountDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import service.branch.place_order.PlaceOrderService;
import service.branch.place_order.PlaceOrderServiceImpl;

@WebServlet("/branch/place_order/history")
public class PlaceOrderController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private final PlaceOrderService placeOrderService = new PlaceOrderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AccountDTO loginUser = getLoginUser(request);
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

        List<PlaceOrderHistoryDTO> historyList = placeOrderService.getPlaceOrderHistoryList(
                loginUser.getBranchCode() != null ? loginUser.getBranchCode() : 1,
                startDate,
                endDate,
                status
        );

        request.setAttribute("placeOrderHistoryList", historyList);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.getRequestDispatcher("/branch/place_order/history.jsp").forward(request, response);
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
}