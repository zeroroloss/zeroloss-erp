package controller.branch.hr;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.hq.hr.BranchOptionDTO;
import dto.branch.hr.EmployeeDTO;
import service.BranchService;
import service.BranchServiceImpl;
import service.branch.EmployeeService;
import service.branch.EmployeeServiceImpl;

/**
 * Servlet implementation class EmployeeManagementController
 */
@WebServlet(urlPatterns = { "/branch/hr/main" })
public class EmployeeMainController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private BranchService branchService = new BranchServiceImpl();
	private EmployeeService employeeService = new EmployeeServiceImpl();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EmployeeMainController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			List<BranchOptionDTO> branchNameList = branchService.searchBranchName();
			dto.branch.hr.EmployeeDTO employee = new EmployeeDTO();
			List<EmployeeDTO> empList = employeeService.searchEmployeeList(employee);
			Integer totalEmp = employeeService.selectEmpCnt();
			Integer totalHqEmp = employeeService.selectHqEmpCnt();
			Integer ptmEmp = employeeService.selectPTMCnt();
			
			request.setAttribute("branchNameList", branchNameList);
			request.setAttribute("employeeList", empList);
			request.setAttribute("totalEmp", totalEmp);
			request.setAttribute("totalHqEmp", totalHqEmp);
			request.setAttribute("ptmEmp", ptmEmp);
			request.getRequestDispatcher("/branch/hr/main.jsp").forward(request, response);
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
