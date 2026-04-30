package controller.branch.hr;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.branch.hr.BranchScheduleDTO;
import dto.branch.hr.EmployeeDTO;
import service.branch.BranchScheduleService;
import service.branch.BranchScheduleServiceImpl;

/**
 * Servlet implementation class BranchScheduleManagementController
 */
@WebServlet("/branch/hr/branchschedule")
public class BranchScheduleManagementController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private BranchScheduleService scheduleService = new BranchScheduleServiceImpl();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BranchScheduleManagementController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			BranchScheduleDTO schedule = new BranchScheduleDTO();
			List<BranchScheduleDTO> scdList = scheduleService.searchBranchScheduleList(schedule);
			List<EmployeeDTO> branchEmpList = scheduleService.selectBranchEmployee();
			
			request.setAttribute("scheduleList", scdList);
			request.setAttribute("branchEmployeeList", branchEmpList);
			request.getRequestDispatcher("/branch/hr/schedule/main.jsp").forward(request, response);
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
