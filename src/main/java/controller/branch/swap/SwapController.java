package controller.branch.swap;

import com.google.gson.Gson;
import dto.AccountDTO;
import dto.branch.swap.MaterialDto;
import dto.branch.swap.MaterialGroupDto;
import dto.branch.swap.SwapStockSearchRequestDto;
import dto.branch.swap.SwapStockSearchResultDto;
import service.branch.swap.SwapService;
import service.branch.swap.SwapServiceImpl;
import util.GsonFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/branch/swap")
public class SwapController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final SwapService swapService = new SwapServiceImpl();
    private final Gson gson = GsonFactory.getGson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // AJAX 요청들은 로그인 체크 없이 먼저 처리 (필요 시 각 핸들러에서 체크)
        if ("getMaterialGroups".equals(action)) {
            handleGetMaterialGroups(request, response);
            return;
        }
        if ("getMaterialsByGroup".equals(action)) {
            handleGetMaterialsByGroup(request, response);
            return;
        }

        // --- 이하 로그인 세션이 필요한 요청 ---
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            response.sendRedirect(request.getContextPath() + "/common/login.jsp");
            return;
        }

        if ("search".equals(action)) {
            AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");
            handleSearchRequest(request, response, loginUser.getBranchCode());
        } else {
            // action이 없거나 다른 값이면 기본 페이지로 포워딩
            request.getRequestDispatcher("/branch/swap/main.jsp").forward(request, response);
        }
    }

    private void handleSearchRequest(HttpServletRequest request, HttpServletResponse response, int currentBranchCode) throws IOException {
        try {
            String materialCode = request.getParameter("item");
            int requiredQty = Integer.parseInt(request.getParameter("qty"));
            int distance = Integer.parseInt(request.getParameter("dist"));

            SwapStockSearchRequestDto searchDto = new SwapStockSearchRequestDto(currentBranchCode, materialCode, requiredQty, distance);
            List<SwapStockSearchResultDto> result = swapService.findNearbyBranchStocks(searchDto);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(result));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"수량 또는 거리 파라미터가 올바른 숫자 형식이 아닙니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"서버 오류가 발생했습니다.\"}");
        }
    }

    private void handleGetMaterialGroups(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            List<MaterialGroupDto> result = swapService.getMaterialGroups();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"재료 그룹을 불러오는 중 오류가 발생했습니다.\"}");
        }
    }

    private void handleGetMaterialsByGroup(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int materialGroupId = Integer.parseInt(request.getParameter("materialGroupId"));
            List<MaterialDto> result = swapService.getMaterialsByGroup(materialGroupId);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(result));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"잘못된 재료 그룹 ID입니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"재료 목록을 불러오는 중 오류가 발생했습니다.\"}");
        }
    }
}
