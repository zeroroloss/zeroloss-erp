package controller.hq.sales;

import com.google.gson.Gson;
import dto.branch.sales.MenuSalesDTO;
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

@WebServlet("/hq/sales/menu")
public class HqMenuSalesController extends HttpServlet {
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
            String dateParam = request.getParameter("date");

            if (branchCodeParam == null || branchCodeParam.isEmpty() ||
                dateParam == null || dateParam.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"'branchCode'와 'date' 파라미터는 비워둘 수 없습니다.\"}");
                return;
            }

            LocalDate targetDate = LocalDate.parse(dateParam);
            List<MenuSalesDTO> menuSales = hqSalesService.getMenuSales(branchCodeParam, targetDate);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(menuSales));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"메뉴별 매출 데이터를 조회하는 중 오류가 발생했습니다.\"}");
        }
    }
}
