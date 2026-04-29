package controller.hq.sales;

import com.google.gson.Gson;
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
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/hq/sales/ranking")
public class HqSalesRankingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 🟢 1. 누락되었던 logger 선언
    private static final Logger logger = Logger.getLogger(HqSalesRankingController.class.getName());

    // 🟢 2. 누락되었던 service, gson 변수 선언
    private final SalesRankingService salesRankingService;
    private final Gson gson;

    // 🟢 3. 누락되었던 생성자 (변수 초기화)
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

        // 날짜 파라미터 받기 (없을 경우 기본값으로 30일 전 ~ 오늘 날짜 세팅)
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        if (startDate == null || startDate.isEmpty()) startDate = LocalDate.now().minusDays(30).toString();
        if (endDate == null || endDate.isEmpty()) endDate = LocalDate.now().toString();

        logger.info("Received action: " + action + ", sortType: " + sortType + ", dates: " + startDate + " ~ " + endDate);

        if ("getRanking".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            try {
                List<SalesRankingDto> ranking;
                if ("quantity".equals(sortType)) {
                    // 날짜 파라미터 추가
                    ranking = salesRankingService.getSalesQuantityRanking(startDate, endDate);
                } else {
                    // 날짜 파라미터 추가
                    ranking = salesRankingService.getSalesRanking(startDate, endDate);
                }
                response.getWriter().write(gson.toJson(ranking));
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"매출 랭킹 데이터를 가져오는 중 오류가 발생했습니다.\"}");
            }
        } else {
            request.getRequestDispatcher("/hq/sales/sales-ranking.jsp").forward(request, response);
        }
    }
}