package controller.hq.place_order;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/hq/place_order/order_quantity_limit")
public class OrderQuantityLimitController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public OrderQuantityLimitController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/hq/place_order/order_quantity_limit.jsp").forward(request, response);
	}

}
