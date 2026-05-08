package controller.hq;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.hq.sales.HqTodaySalesSummaryDTO;
import service.hq.EmployeeService;
import service.hq.EmployeeServiceImpl;
import service.hq.place_order.PlaceOrderOverviewService;
import service.hq.place_order.PlaceOrderOverviewServiceImpl;
import service.hq.sales.HqSalesService;
import service.hq.sales.HqSalesServiceImpl;
import service.hq.warehouse.WarehouseStockAlertService;
import service.hq.warehouse.WarehouseStockAlertServiceImpl;

@WebServlet("/hq/main/home")
public class HqMainController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private EmployeeService employeeService = new EmployeeServiceImpl();
	private PlaceOrderOverviewService overviewService = new PlaceOrderOverviewServiceImpl();
	private HqSalesService hqSalesService = new HqSalesServiceImpl();
       
    public HqMainController() {
        super();
    }
    
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session = request.getSession(false);
			if (session == null || session.getAttribute("accountId") == null) {
				response.sendRedirect(request.getContextPath() + "/login");
			    return;
			}
			
			// 물류창고 알림 체크
			int accountId = (int) request.getSession().getAttribute("accountId");
	        WarehouseStockAlertService warehouseStockAlertService = new WarehouseStockAlertServiceImpl();
	        warehouseStockAlertService.sendWarehouseAlerts(accountId);
	        
			Integer totalEmp = employeeService.selectEmpCnt();
			Integer totalBranch = employeeService.selectBranchCnt();
			Integer totalPending = overviewService.selectPendingCnt();
			HqTodaySalesSummaryDTO salesSummary = hqSalesService.getTodaySalesSummary(LocalDate.now());
			
			request.setAttribute("totalEmp", totalEmp);
			request.setAttribute("totalBranch", totalBranch);
			request.setAttribute("totalPending", totalPending);
			request.setAttribute("monthlySales", salesSummary.getMonthlyCumulativeSales());
			request.getRequestDispatcher("/hq/main/home.jsp").forward(request, response);
			return;
		} catch(Exception e) {
			e.printStackTrace();
			
			if(!response.isCommitted()) {
				request.setAttribute("errorMsg", e.getMessage());
				request.setAttribute("errorUrl", request.getRequestURI());
				request.getRequestDispatcher("/common/500.jsp").forward(request, response);
			}
		}
	}

}
