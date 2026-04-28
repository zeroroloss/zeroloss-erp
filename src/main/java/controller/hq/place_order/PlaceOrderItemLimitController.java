package controller.hq.place_order;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/hq/place_order/item_limit")
public class PlaceOrderItemLimitController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public PlaceOrderItemLimitController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/hq/place_order/item_limit.jsp").forward(request, response);
	}

}
