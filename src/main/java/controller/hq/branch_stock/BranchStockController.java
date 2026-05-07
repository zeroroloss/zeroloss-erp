package controller.hq.branch_stock;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dto.hq.branch_stock.BranchDTO;
import dto.hq.branch_stock.BranchStockListDTO;
import dto.hq.branch_stock.BranchStockSearchDTO;
import dto.hq.branch_stock.MaterialDTO;
import dto.hq.branch_stock.MaterialGroupDTO;
import service.hq.BranchStockService;
import service.hq.BranchStockServiceImpl;

@WebServlet("/hq/branch_stock/stock")
public class BranchStockController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private BranchStockService branchStockService = new BranchStockServiceImpl();
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String materialGroupIdStr = request.getParameter("materialGroupId");
		String ajax = request.getParameter("ajax");
		String type = request.getParameter("type");

		if ("material".equals(type) && materialGroupIdStr != null && !"".equals(materialGroupIdStr)) {
		    int materialGroupId = Integer.parseInt(materialGroupIdStr);

		    List<MaterialDTO> list = branchStockService.findMaterialByCategory(materialGroupId);

		    response.setContentType("application/json;charset=UTF-8");
		    new Gson().toJson(list, response.getWriter());
		    return;
		}
		
		if ("true".equals(ajax)) {
			searchStockList(request, response);
			return;
		}

		List<BranchDTO> branchList = branchStockService.findBranchList();
		List<MaterialGroupDTO> materialGroupList = branchStockService.findMaterialGroupList();

		request.setAttribute("branchList", branchList);
		request.setAttribute("materialGroupList", materialGroupList);
		request.getRequestDispatcher("/hq/branch_stock/stock.jsp").forward(request, response);
	}

	private void searchStockList(HttpServletRequest request, HttpServletResponse response) throws IOException {

		BranchStockSearchDTO searchDTO = new BranchStockSearchDTO();
		searchDTO.setBranchCode(request.getParameter("branchCode"));
		searchDTO.setMaterialCode(request.getParameter("materialCode"));
		searchDTO.setKeyword(request.getParameter("keyword"));

		String materialGroupId = request.getParameter("materialGroupId");
		String expireWithinDaysStr = request.getParameter("expireWithinDays");
		String stockStatus = request.getParameter("stockStatus");

		if (materialGroupId != null && !"".equals(materialGroupId)) {
			searchDTO.setMaterialGroupId(Integer.parseInt(materialGroupId));
		}		
		
		if (expireWithinDaysStr != null && !expireWithinDaysStr.isEmpty()) {
		    searchDTO.setExpireWithinDays(Integer.parseInt(expireWithinDaysStr));
		}
		
		if (stockStatus != null && !stockStatus.isEmpty()) {
		    searchDTO.setStockStatus(stockStatus);
		}

		List<BranchStockListDTO> stockList = branchStockService.findStockList(searchDTO);

		response.setContentType("application/json;charset=UTF-8");
		new Gson().toJson(stockList, response.getWriter());

	}

}
