package controller.hq.support;

import dto.BranchDTO;
import service.BranchService;
import service.BranchServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/hq/support/inquiries")
public class HeadquartersInquiriesPageController extends HttpServlet {

    private final BranchService branchService = new BranchServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<BranchDTO> branches = branchService.getAllBranches();
            req.setAttribute("branches", branches);
            req.getRequestDispatcher("/hq/support/headquarters-inquiries.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "지점 목록을 불러오는 데 실패했습니다.");
        }
    }
}
