package controller.branch;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import service.branch.EmployeeService;
import service.branch.EmployeeServiceImpl;
import service.branch.stock.BranchStockAlertService;
import service.branch.stock.BranchStockAlertServiceImpl;

@WebServlet("/branch/main/home")
public class BranchMainController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private EmployeeService employeeService = new EmployeeServiceImpl();
       
    public BranchMainController() {
        super();
    }

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session = request.getSession();
			Integer branchCode = (Integer)session.getAttribute("branchCode");
			Integer accountId  = (Integer) session.getAttribute("accountId");
			Integer todayEmp = employeeService.selectTodayEmpCnt(branchCode);
			
			 // 재고 알림 체크
	        BranchStockAlertService branchStockAlertService = new BranchStockAlertServiceImpl();
	        branchStockAlertService.sendStockAlerts(branchCode, accountId);
			
			request.setAttribute("todayEmp", todayEmp);
			request.getRequestDispatcher("/branch/main/home.jsp").forward(request, response);
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
