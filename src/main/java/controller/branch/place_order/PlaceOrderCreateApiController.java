package controller.branch.place_order;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dto.hq.place_order.PlaceOrderMaterialDTO;
import service.branch.place_order.PlaceOrderService;
import service.branch.place_order.PlaceOrderServiceImpl;

@WebServlet("/api/branch/place_order/create")
public class PlaceOrderCreateApiController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
    public PlaceOrderCreateApiController() {
        super();
    }

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		

		
		
		request.getRequestDispatcher("/branch/place_order/create.jsp").forward(request, response);
	}
    
}