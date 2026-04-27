package controller.hq.hr;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.hq.hr.EmployeeDTO;
import service.hq.EmployeeService;
import service.hq.EmployeeServiceImpl;

/**
 * Servlet implementation class EmployeeManagementController
 */
@WebServlet("/hq/hr/employee")
public class EmployeeManagementController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private EmployeeService employeeService = new EmployeeServiceImpl();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EmployeeManagementController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			EmployeeDTO employee = new EmployeeDTO();
			List<EmployeeDTO> empList = employeeService.searchEmployeeList(employee);
			Integer totalEmp = employeeService.selectEmpCnt();
			Integer totalBranch = employeeService.selectBranchCnt();
			Integer newEmpCnt = employeeService.selectNewEmpCnt();
			
			request.setAttribute("employeeList", empList);
			request.setAttribute("totalEmp", totalEmp);
			request.setAttribute("totalBranch", totalBranch);
			request.setAttribute("newEmpCnt", newEmpCnt);
			request.getRequestDispatcher("/hq/hr/hr-employee-inquiry.jsp").forward(request, response);
		} catch(Exception e) {
			e.printStackTrace();
			request.setAttribute("errorMsg", e.getMessage());
			request.setAttribute("errorUrl", request.getRequestURI());
			request.getRequestDispatcher("/common/500.jsp").forward(request, response);
		}
	}
		
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
