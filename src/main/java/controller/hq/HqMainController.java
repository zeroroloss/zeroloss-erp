package controller.hq;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.hq.hr.EmployeeDTO;
import service.hq.EmployeeService;
import service.hq.EmployeeServiceImpl;
import service.hq.place_order.PlaceOrderOverviewService;
import service.hq.place_order.PlaceOrderOverviewServiceImpl;

/**
 * Servlet implementation class HqMainController
 */
@WebServlet("/hq/main/home")
public class HqMainController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private EmployeeService employeeService = new EmployeeServiceImpl();
	private PlaceOrderOverviewService overviewService = new PlaceOrderOverviewServiceImpl();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public HqMainController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			EmployeeDTO employee = new EmployeeDTO();
			Integer totalEmp = employeeService.selectEmpCnt();
			Integer totalBranch = employeeService.selectBranchCnt();
			Integer totalPending = overviewService.selectPendingCnt();
			
			request.setAttribute("totalEmp", totalEmp);
			request.setAttribute("totalBranch", totalBranch);
			request.setAttribute("totalPending", totalPending);
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
