package controller.hq.sales;

import com.google.gson.Gson;
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

@WebServlet("/hq/sales/headquarters")
public class HqHeadquartersSalesController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final HqSalesService hqSalesService = new HqSalesServiceImpl();
    private final Gson gson = GsonFactory.getGson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            response.sendRedirect(request.getContextPath() + "/common/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            request.getRequestDispatcher("/hq/sales/sales-headquarters.jsp").forward(request, response);
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            Object result = null;
            switch (action) {
                case "summary":
                    result = hqSalesService.getTodaySalesSummary(LocalDate.now());
                    break;
                case "search":
                    result = searchSalesData(request);
                    break;
                case "mainCategories":
                    result = hqSalesService.getAllMainCategories();
                    break;
                case "menus":
                    int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                    result = hqSalesService.getMenusByCategory(categoryId);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Invalid action\"}");
                    return;
            }
            response.getWriter().write(gson.toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"데이터를 조회하는 중 오류가 발생했습니다.\"}");
        }
    }

    private Object searchSalesData(HttpServletRequest request) {
        String filterType = request.getParameter("filterType");
        LocalDate targetDate;
        LocalDate startDate;
        LocalDate endDate;

        try {
            switch (filterType) {
                case "date":
                    String dateParam = request.getParameter("dateInput");
                    targetDate = (dateParam != null && !dateParam.isEmpty()) ? LocalDate.parse(dateParam) : LocalDate.now();
                    return hqSalesService.getDailySales("all", targetDate);
                case "period":
                    String startDateParam = request.getParameter("startDateInput");
                    String endDateParam = request.getParameter("endDateInput");
                    startDate = (startDateParam != null && !startDateParam.isEmpty()) ? LocalDate.parse(startDateParam) : LocalDate.now().minusMonths(1);
                    endDate = (endDateParam != null && !endDateParam.isEmpty()) ? LocalDate.parse(endDateParam) : LocalDate.now();
                    return hqSalesService.getPeriodSales("all", startDate, endDate);
                case "menu":
                    String menuDateParam = request.getParameter("dateInput");
                    endDate = (menuDateParam != null && !menuDateParam.isEmpty()) ? LocalDate.parse(menuDateParam) : LocalDate.now();

                    int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                    String recipeCode = request.getParameter("recipeCode");

                    if (recipeCode == null || recipeCode.isEmpty() || "all".equals(recipeCode)) {
                        // 시나리오 1: 카테고리 내 메뉴별 랭킹
                        return hqSalesService.getMenuSalesRanksByCategory(endDate, categoryId);
                    } else {
                        // 시나리오 2: 메뉴의 지점별 주간 랭킹
                        startDate = endDate.minusDays(6);
                        return hqSalesService.getBranchSalesRanksByMenu(startDate, endDate, recipeCode);
                    }
                default:
                    return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
