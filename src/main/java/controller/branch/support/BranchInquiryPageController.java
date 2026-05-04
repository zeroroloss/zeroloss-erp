package controller.branch.support;

import dto.BranchDTO;
import service.BranchService;
import service.BranchServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/branch/support/inquiries")
public class BranchInquiryPageController extends HttpServlet {

    private final BranchService branchService = new BranchServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/common/login.jsp");
            return;
        }

        try {
            List<BranchDTO> branches = branchService.getAllBranches();
            req.setAttribute("branches", branches);
            req.getRequestDispatcher("/branch/support/branch-inquiries.jsp").forward(req, resp);
        } catch (Exception e) {
            System.err.println("BranchInquiryPageController error: " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "지점 목록을 불러오는 데 실패했습니다.");
        }
    }
}
