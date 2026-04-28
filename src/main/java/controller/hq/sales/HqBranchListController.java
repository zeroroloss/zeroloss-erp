package controller.hq.sales;

import com.google.gson.Gson;
import dto.BranchDTO;
import service.hq.sales.HqSalesService;
import service.hq.sales.HqSalesServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/hq/sales/branches")
public class HqBranchListController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final HqSalesService hqSalesService = new HqSalesServiceImpl();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<BranchDTO> branches = hqSalesService.getActiveBranches();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(branches));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"지점 목록을 불러오는 중 오류가 발생했습니다.\"}");
        }
    }
}
