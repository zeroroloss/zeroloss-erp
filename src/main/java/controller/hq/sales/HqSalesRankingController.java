package controller.hq.sales;

import com.google.gson.Gson;
import dto.hq.sales.DailySalesTrendDto;
import dto.hq.sales.HourlySalesTrendDto;
import dto.hq.sales.MenuCategoryDto;
import dto.hq.sales.MenuDto;
import dto.hq.sales.SalesRankingDto;
import service.hq.sales.SalesRankingService;
import service.hq.sales.SalesRankingServiceImpl;
import util.GsonFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/hq/sales/ranking")
public class HqSalesRankingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final Logger logger = Logger.getLogger(HqSalesRankingController.class.getName());

    private final SalesRankingService salesRankingService;
    private final Gson gson;

    public HqSalesRankingController() {
        this.salesRankingService = new SalesRankingServiceImpl();
        this.gson = GsonFactory.getGson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            response.sendRedirect(request.getContextPath() + "/common/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String sortType = request.getParameter("sortType");

        // 프론트엔드에서 보낸 탭 종류(branch, menu, specific_menu 등) 파라미터 받기
        String rankType = request.getParameter("rankType");

        // 🟢 1. 특정 메뉴 집중 분석 시 선택된 메뉴 코드 받기
        String recipeCode = request.getParameter("recipeCode");

        // 날짜 파라미터 받기 (없을 경우 기본값으로 30일 전 ~ 오늘 날짜 세팅)
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        if (startDate == null || startDate.isEmpty()) startDate = LocalDate.now().minusDays(30).toString();
        if (endDate == null || endDate.isEmpty()) endDate = LocalDate.now().toString();

        logger.info("Received action: " + action + ", rankType: " + rankType + ", sortType: " + sortType + ", dates: " + startDate + " ~ " + endDate + ", recipeCode: " + recipeCode);

        response.setContentType("application/json"); // JSON 응답을 기본으로 설정
        response.setCharacterEncoding("UTF-8");

        try {
            if ("getRanking".equals(action)) {
                List<SalesRankingDto> ranking;

                // rankType에 따라 Service 호출 분기
                if ("menu".equals(rankType)) {
                    // 전사 메뉴별 랭킹 탭
                    if ("quantity".equals(sortType)) {
                        ranking = salesRankingService.getMenuQuantityRanking(startDate, endDate);
                    } else {
                        ranking = salesRankingService.getMenuSalesRanking(startDate, endDate);
                    }
                } else if ("specific_menu".equals(rankType)) {
                    // 🟢 2. 특정 메뉴 집중 분석 탭 로직 추가
                    if ("quantity".equals(sortType)) {
                        ranking = salesRankingService.getSpecificMenuQuantityRanking(startDate, endDate, recipeCode);
                    } else {
                        ranking = salesRankingService.getSpecificMenuSalesRanking(startDate, endDate, recipeCode);
                    }
                } else {
                    // 기본값: 지점 종합 랭킹 탭 (branch)
                    if ("quantity".equals(sortType)) {
                        ranking = salesRankingService.getSalesQuantityRanking(startDate, endDate);
                    } else {
                        ranking = salesRankingService.getSalesRanking(startDate, endDate);
                    }
                }
                response.getWriter().write(gson.toJson(ranking));
            } else if ("getMenuCategories".equals(action)) { // 🟢 추가: 메뉴 카테고리 조회
                List<MenuCategoryDto> categories = salesRankingService.getAllMenuCategories();
                response.getWriter().write(gson.toJson(categories));
            } else if ("getMenusByCategory".equals(action)) { // 🟢 추가: 특정 카테고리 메뉴 조회
                String categoryCodeStr = request.getParameter("categoryCode");
                if (categoryCodeStr != null && !categoryCodeStr.isEmpty()) {
                    try {
                        int categoryCode = Integer.parseInt(categoryCodeStr);
                        List<MenuDto> menus = salesRankingService.getMenusByCategory(categoryCode);
                        response.getWriter().write(gson.toJson(menus));
                    } catch (NumberFormatException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("{\"error\": \"유효하지 않은 categoryCode 파라미터입니다.\"}");
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"categoryCode 파라미터가 필요합니다.\"}");
                }
            } else if ("getTrendData".equals(action)) { // 🟢 추가: 전사 트렌드 데이터 조회
                Map<String, Object> trendData = new HashMap<>();

                List<HourlySalesTrendDto> hourlyTrend = salesRankingService.getHourlySalesTrend(startDate, endDate);
                List<DailySalesTrendDto> dailyTrend = salesRankingService.getDailySalesTrend(startDate, endDate);

                trendData.put("hourly", hourlyTrend);
                trendData.put("daily", dailyTrend);

                response.getWriter().write(gson.toJson(trendData));
            }
            else {
                // action이 getRanking, getMenuCategories, getMenusByCategory, getTrendData가 아닐 경우 JSP 페이지로 포워드
                response.setContentType("text/html"); // JSP 페이지는 HTML을 반환하므로 Content-Type 변경
                request.getRequestDispatcher("/hq/sales/sales-ranking.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"데이터를 가져오는 중 오류가 발생했습니다.\"}");
        }
    }
}
