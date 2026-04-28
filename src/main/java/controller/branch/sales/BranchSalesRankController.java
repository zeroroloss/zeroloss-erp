package controller.branch.sales;

import com.google.gson.Gson;
import dto.AccountDTO;
import service.branch.sales.BranchSalesRankService;
import dto.RankDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/branch/sales/rank")
public class BranchSalesRankController extends HttpServlet {

    private final BranchSalesRankService salesRankService = new BranchSalesRankService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(Map.of("error", "로그인이 필요합니다.")));
            return;
        }

        String branchCode = String.valueOf(loginUser.getBranchCode());
        String rankType = request.getParameter("rankType");
        String sort = request.getParameter("sort");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        try {
            List<RankDTO> top10 = salesRankService.getTop10(branchCode, rankType, sort, startDate, endDate);
            List<RankDTO> worst10 = salesRankService.getWorst10(branchCode, rankType, sort, startDate, endDate);

            Map<String, List<RankDTO>> result = new HashMap<>();
            result.put("top10", top10);
            result.put("worst10", worst10);

            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(Map.of("error", "데이터 조회 중 오류가 발생했습니다.")));
        }
    }
}
