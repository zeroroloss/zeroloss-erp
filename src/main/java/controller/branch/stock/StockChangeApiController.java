package controller.branch.stock;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;

import dto.AccountDTO;
import dto.BranchStockChangeHistoryDTO;
import dto.BranchStockDisposalHistoryDTO;
import service.branch.stock.BranchStockHistoryService;
import service.branch.stock.BranchStockHistoryServiceImpl;

@WebServlet("/branch/stock_change/view")
public class StockChangeApiController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public StockChangeApiController() {
        super();
    }
    
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json;charset=UTF-8");

        try {
            AccountDTO loginUser = getLoginUser(request);
            if (loginUser == null) {
                response.setStatus(401);
                return;
            }

            int branchCode = loginUser.getBranchCode();
            String tab     = request.getParameter("tab");
            int page       = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int pageSize   = 10;
            int offset     = (page - 1) * pageSize;

            Map<String, Object> params = new HashMap<>();
            params.put("branchCode",      branchCode);
            params.put("materialGroupId", request.getParameter("materialGroupId"));
            params.put("materialName",    request.getParameter("materialName"));
            params.put("startDate",       request.getParameter("startDate"));
            params.put("endDate",         request.getParameter("endDate"));
            params.put("pageSize",        pageSize);
            params.put("offset",          offset);

            BranchStockHistoryService branchStockHistoryService = new BranchStockHistoryServiceImpl();

            Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class,
                    (JsonSerializer<LocalDateTime>) (src, type, ctx) ->
                        new JsonPrimitive(src.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))))
                .registerTypeAdapter(BigDecimal.class,
                    (JsonSerializer<BigDecimal>) (src, type, ctx) ->
                        new JsonPrimitive(src.toPlainString()))
                .create();

            Map<String, Object> result = new HashMap<>();

            if ("disposal".equals(tab)) {
                List<BranchStockDisposalHistoryDTO> list = branchStockHistoryService.selectDisposalHistory(params);
                int totalCount = branchStockHistoryService.selectDisposalHistoryCount(params);
                result.put("list",       list);
                result.put("totalCount", totalCount);
                result.put("page",       page);
                result.put("pageSize",   pageSize);
                result.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));
            } else {
                List<BranchStockChangeHistoryDTO> list = branchStockHistoryService.selectStockChangeHistory(params);
                int totalCount = branchStockHistoryService.selectStockChangeHistoryCount(params);
                result.put("list",       list);
                result.put("totalCount", totalCount);
                result.put("page",       page);
                result.put("pageSize",   pageSize);
                result.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));
            }

            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"서버 오류가 발생했습니다.\"}");
        }
    }

    private AccountDTO getLoginUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (AccountDTO) session.getAttribute("loginUser");
    }

}
