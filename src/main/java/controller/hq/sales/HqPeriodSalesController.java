package controller.hq.sales;

import com.google.gson.Gson;
import dto.branch.sales.DailySalesDTO;
import service.hq.sales.HqSalesService;
import service.hq.sales.HqSalesServiceImpl;
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

@WebServlet("/hq/sales/period")
public class HqPeriodSalesController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final HqSalesService hqSalesService = new HqSalesServiceImpl();
    private final Gson gson = GsonFactory.getGson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"로그인이 필요합니다.\"}");
            return;
        }

        try {
            String branchCodeParam = request.getParameter("branchCode");
            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");

            if (branchCodeParam == null || branchCodeParam.isEmpty() ||
                startDateParam == null || startDateParam.isEmpty() ||
                endDateParam == null || endDateParam.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"'branchCode', 'startDate', 'endDate' 파라미터는 비워둘 수 없습니다.\"}");
                return;
            }

            LocalDate startDate = LocalDate.parse(startDateParam);
            LocalDate endDate = LocalDate.parse(endDateParam);
            List<DailySalesDTO> periodSales = hqSalesService.getPeriodSales(branchCodeParam, startDate, endDate);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(periodSales));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"기간별 매출 데이터를 조회하는 중 오류가 발생했습니다.\"}");
        }
    }
}
