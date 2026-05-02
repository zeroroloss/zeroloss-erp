package controller.hq.place_order;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import service.hq.place_order.PlaceOrderOverviewService;
import service.hq.place_order.PlaceOrderOverviewServiceImpl;
import util.GsonFactory;

@WebServlet("/hq/place_order/overview")
public class PlaceOrderOverviewController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final PlaceOrderOverviewService overviewService = new PlaceOrderOverviewServiceImpl();
	private Gson gson = GsonFactory.getGson();
       
    public PlaceOrderOverviewController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// 지점명 가져오기 & 페이지에 넘겨주기
		List<String> branchNames = overviewService.findAllBranchNames();
		if (branchNames == null) branchNames = new ArrayList<>();
		request.setAttribute("branchNames", branchNames);
		request.getRequestDispatcher("/hq/place_order/overview.jsp").forward(request, response);
	}
}
