package controller.branch;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.hq.hr.EmployeeDTO;
import dto.hq.sales.HqTodaySalesSummaryDTO;

/**
 * Servlet implementation class BranchMainController
 */
@WebServlet("/branch/main/home")
public class BranchMainController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BranchMainController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			
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
