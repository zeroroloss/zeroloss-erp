package controller.hq.warehouse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.hq.warehouse.WarehouseOutboundService;
import service.hq.warehouse.WarehouseOutboundServiceImpl;

@WebServlet("/hq/warehouse/outbound")
public class WarehouseOutboundController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	private final WarehouseOutboundService outboundService = new WarehouseOutboundServiceImpl();
       
	public WarehouseOutboundController() {
		super();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 지점명 가져오기 & 페이지에 넘겨주기
		List<String> branchNames = outboundService.findAllBranchNames();
		if (branchNames == null) branchNames = new ArrayList<>();
		request.setAttribute("branchNames", branchNames);
		request.getRequestDispatcher("/hq/warehouse/outbound.jsp").forward(request, response);

	}
}
