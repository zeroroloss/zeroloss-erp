package controller.hq.support;

import com.google.gson.Gson;
import dto.HqBranchSearchDTO;
import service.hq.BranchSearchService;
import service.hq.BranchSearchServiceImpl;
import util.GsonFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/hq/support/branch-search")
public class BranchSearchController extends HttpServlet {

    private final BranchSearchService branchSearchService = new BranchSearchServiceImpl();
    private final Gson gson = GsonFactory.getGson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String region = req.getParameter("region");
        String keyword = req.getParameter("keyword");

        try {
            List<HqBranchSearchDTO> branches = branchSearchService.searchBranches(region, keyword);
            resp.getWriter().write(gson.toJson(branches));

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> errorRes = new HashMap<>();
            errorRes.put("error", e.getClass().getSimpleName());
            errorRes.put("message", e.getMessage());
            resp.getWriter().write(gson.toJson(errorRes));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if (action == null) action = "create"; // 기본값 방어

        try {
            if ("delete".equals(action)) {
                // 삭제 처리
                String id = req.getParameter("id");
                branchSearchService.deleteBranch(id);
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("{\"status\":\"success\"}");
                return;
            }

            // 등록 & 수정은 JSON 바디를 읽어야 함
            String requestBody = req.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
            HqBranchSearchDTO branchDTO = gson.fromJson(requestBody, HqBranchSearchDTO.class);

            if ("update".equals(action)) {
                branchSearchService.updateBranch(branchDTO);
            } else {
                branchSearchService.createBranch(branchDTO);
            }

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("{\"status\":\"success\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
