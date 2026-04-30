package controller.hq.branch_stock;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dto.hq.branch_stock.BranchDTO;
import dto.hq.branch_stock.BranchRiskSearchDTO;
import dto.hq.branch_stock.BranchRiskSummaryDTO;
import dto.hq.branch_stock.DisposalRiskDTO;
import dto.hq.branch_stock.ExpireRiskDTO;
import service.hq.BranchRiskService;
import service.hq.BranchRiskServiceImpl;
import service.hq.BranchStockService;
import service.hq.BranchStockServiceImpl;

@WebServlet("/hq/branch_stock/loss")
public class BranchStockLossController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private BranchRiskService branchRiskService = new BranchRiskServiceImpl();
	private BranchStockService branchStockService = new BranchStockServiceImpl();
       
    public BranchStockLossController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		LocalDate today = LocalDate.now();
		
		List<BranchDTO> branchList = branchStockService.findBranchList();
		
		request.setAttribute("branchList", branchList);
		
		request.setAttribute("startDate", today.withDayOfMonth(1).toString());
		request.setAttribute("endDate", today.toString());
		
		request.getRequestDispatcher("/hq/branch_stock/loss.jsp").forward(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");

		BranchRiskSearchDTO searchDTO = new BranchRiskSearchDTO();

		String branchCode = request.getParameter("branchCode");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");

		LocalDate today = LocalDate.now();
		
		if (startDate == null || startDate.isEmpty()) {
			startDate = today.withDayOfMonth(1).toString();
		}

		if (endDate == null || endDate.isEmpty()) {
			endDate = today.toString();
		}

		if (branchCode != null && !branchCode.isEmpty()) {
			searchDTO.setBranchCode(Integer.parseInt(branchCode));
		}

		searchDTO.setStartDate(startDate);
		searchDTO.setEndDate(endDate);

		BranchRiskSummaryDTO summary = branchRiskService.getRiskSummary(searchDTO);
		List<ExpireRiskDTO> expireRiskList = branchRiskService.getExpireRiskList(searchDTO);
		List<DisposalRiskDTO> disposalRiskList = branchRiskService.getDisposalRiskList(searchDTO);

		Map<String, Object> result = new HashMap<>();
		result.put("summary", summary);
		result.put("expireRiskList", expireRiskList);
		result.put("disposalRiskList", disposalRiskList);

		response.getWriter().write(new Gson().toJson(result));
	
	}

}
