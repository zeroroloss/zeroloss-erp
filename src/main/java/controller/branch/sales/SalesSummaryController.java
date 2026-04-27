package controller.branch.sales;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dto.AccountDTO;
import dto.branch.sales.SalesSummaryDTO;
import service.branch.sales.SalesService;
import service.branch.sales.SalesServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/branch/sales/summary")
public class SalesSummaryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final SalesService salesService = new SalesServiceImpl();
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\": \"Unauthenticated\"}");
            return;
        }

        try {
            int branchCode = loginUser.getBranchCode();
            SalesSummaryDTO summary = salesService.getSalesSummary(branchCode);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(summary));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Summary load failed\"}");
        }
    }
}