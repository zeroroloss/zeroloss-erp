package controller.branch.sales;

import com.google.gson.Gson;
import dto.AccountDTO;
import dto.branch.sales.HourlySalesDTO;
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

@WebServlet("/branch/sales/hourly")
public class HourlySalesController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final SalesService salesService = new SalesServiceImpl();
    private final Gson gson = GsonFactory.getGson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\": \"로그인 세션이 만료되었습니다. 다시 로그인해주세요.\"}");
            return;
        }

        try {
            String dateParam = request.getParameter("date");
            LocalDate targetDate;

            if (dateParam == null || dateParam.isEmpty()) {
                targetDate = LocalDate.now(); // 날짜 미지정 시 오늘 기준
            } else {
                targetDate = LocalDate.parse(dateParam);
            }

            int branchCode = loginUser.getBranchCode();
            List<HourlySalesDTO> hourlySales = salesService.getHourlySales(branchCode, targetDate);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(hourlySales));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\": \"시간대별 매출 데이터를 조회하는 중 서버 오류가 발생했습니다.\"}");
        }
    }
}
