package controller.branch.sales;

import com.google.gson.Gson;
import dto.AccountDTO;
import dto.branch.sales.DailySalesDTO;
import service.branch.sales.SalesService;
import service.branch.sales.SalesServiceImpl;
import util.GsonFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Controller for Period Sales Data
 * - 기간별 매출 데이터 요청을 처리하는 서블릿
 * - URL: /branch/sales/period
 */
@WebServlet("/branch/sales/period")
public class PeriodSalesController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final SalesService salesService = new SalesServiceImpl();
    private final Gson gson = GsonFactory.getGson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");

        if (loginUser == null || loginUser.getBranchCode() == 0) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"로그인이 필요하거나, 권한이 없는 사용자입니다.\"}");
            return;
        }

        try {
            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");

            if (startDateParam == null || startDateParam.isEmpty() || endDateParam == null || endDateParam.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"'startDate'와 'endDate' 파라미터가 필요합니다.\"}");
                return;
            }

            LocalDate startDate = LocalDate.parse(startDateParam);
            LocalDate endDate = LocalDate.parse(endDateParam);
            int branchCode = loginUser.getBranchCode();

            List<DailySalesDTO> periodSales = salesService.getPeriodSales(branchCode, startDate, endDate);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(periodSales));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"데이터를 조회하는 중 오류가 발생했습니다.\"}");
        }
    }
}
