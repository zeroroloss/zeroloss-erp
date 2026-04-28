package controller.branch.stock;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/branch/stock/stock_change")
public class StockChangeController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public StockChangeController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/branch/stock/stock_change.jsp").forward(request, response);
	}

}
