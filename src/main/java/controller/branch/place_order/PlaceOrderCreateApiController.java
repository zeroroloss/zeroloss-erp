package controller.branch.place_order;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/api/branch/place_order/create")
public class PlaceOrderCreateApiController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
       
    public PlaceOrderCreateApiController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// 안전재고 미달 품목 넘겨주기
		
		
		request.getRequestDispatcher("/branch/place_order/create.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}
