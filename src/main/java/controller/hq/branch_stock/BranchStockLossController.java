package controller.hq.branch_stock;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/hq/branch_stock/loss")
public class BranchStockLossController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public BranchStockLossController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/hq/branch_stock/loss.jsp").forward(request, response);
	}

}
