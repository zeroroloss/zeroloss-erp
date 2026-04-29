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
			Integer branchCode = (Integer) request.getSession().getAttribute("branchCode");
			List<BranchOptionDTO> branchNameList = branchService.searchBranchName();
			dto.branch.hr.EmployeeDTO employee = new EmployeeDTO();
			employee.setBranchCode(branchCode);
			List<EmployeeDTO> empList = employeeService.searchEmployeeList(branchCode);
			Integer totalEmp = employeeService.selectEmpCnt(branchCode);
			Integer totalHqEmp = employeeService.selectHqEmpCnt(branchCode);
			Integer ptmEmp = employeeService.selectPTMCnt(branchCode);
			
			request.setAttribute("branchNameList", branchNameList);
			request.setAttribute("employeeList", empList);
			request.setAttribute("totalEmp", totalEmp);
			request.setAttribute("totalHqEmp", totalHqEmp);
			request.setAttribute("ptmEmp", ptmEmp);
			request.getRequestDispatcher("/branch/hr/employee/main.jsp").forward(request, response);
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
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");	
		String action = request.getParameter("action");
		
		try {
			if("add".equals(action)) {
				addEmployee(request,response);
			} else if("update".equals(action)) {
				updateEmployee(request,response);
			} else {
				response.getWriter().write("{\"success\":false,\"message\":\"잘못된 요청입니다.\"}");
			}
		} catch(Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"success\":false,\"message\":\"서버 오류\"}");
		}
	}
	
	private void addEmployee(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
		int empNo = Integer.parseInt(request.getParameter("empNo"));
		String positionCode = request.getParameter("positionCode");
		String hireDateStr = request.getParameter("hireDate");
		EmployeeDTO emp = new EmployeeDTO();
		emp.setBranchCode(Integer.parseInt(request.getParameter("branchCode")));
		emp.setPhone(request.getParameter("phone"));

	    if (emp.getPhone() == null || emp.getPhone().trim().isEmpty()) {
	        response.getWriter().write("{\"success\":false,\"message\":\"전화번호를 입력해주세요.\"}");
	        return;
	    }
	    
	    // 2. 이미 등록된 직원/사번인지 확인
	    EmployeeDTO empCheck = employeeService.selectEmployee(empNo);
	    EmployeeDTO employeeCheck = employeeService.selectEmployeeByPhone(emp);
	    
	    if (empCheck != null) {
	        response.getWriter().write("{\"success\":false,\"message\":\"이미 존재하는 사번입니다.\"}");
	        return;
	    }
	    if (employeeCheck != null) {
	    	response.getWriter().write("{\"success\":false,\"message\":\"이미 계정이 존재하는 직원입니다.\"}");
	    	return;
	    }

	    EmployeeDTO employee = new EmployeeDTO();

	    employee.setEmpNo(Integer.parseInt(request.getParameter("empNo")));
	    employee.setName(request.getParameter("name"));
	    employee.setBranchCode(Integer.parseInt(request.getParameter("branchCode")));
	    employee.setDept(request.getParameter("dept"));
	    if (positionCode == null || positionCode.isEmpty()) {
	    	employee.setPositionCode(null);
	    } else {
	    	employee.setPositionCode(positionCode);
	    }
	    employee.setPhone(request.getParameter("phone"));
	    employee.setEmail(request.getParameter("email"));
	    if (hireDateStr != null && !hireDateStr.isEmpty()) {
	    	employee.setHireDate(java.sql.Date.valueOf(hireDateStr));
	    }
	    employee.setStatus(request.getParameter("status"));

	    employeeService.addEmployee(employee);

        response.getWriter().write("{\"success\":true}");
    }

	private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
		String positionCode = request.getParameter("positionCode");
		
	    EmployeeDTO employee = new EmployeeDTO();
	    employee.setEmpNo(Integer.parseInt(request.getParameter("empNo")));
	    employee.setBranchCode(Integer.parseInt(request.getParameter("branchCode")));
	    employee.setDept(request.getParameter("dept"));
	    if (positionCode == null || positionCode.isEmpty()) {
	    	employee.setPositionCode(null);
	    } else {
	    	employee.setPositionCode(positionCode);
	    }
	    employee.setPhone(request.getParameter("phone"));
	    employee.setEmail(request.getParameter("email"));
	    employee.setStatus(request.getParameter("status"));
	    
	    employeeService.modifyEmployee(employee);

	    response.getWriter().write("{\"success\":true}");
	}
}
