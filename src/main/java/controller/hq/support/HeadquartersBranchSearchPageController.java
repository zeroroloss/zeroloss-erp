package controller.hq.support;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/hq/support/branch-search")
public class HeadquartersBranchSearchPageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/common/login.jsp");
            return;
        }

        req.getRequestDispatcher("/hq/support/branch-search.jsp").forward(req, resp);
    }
}
