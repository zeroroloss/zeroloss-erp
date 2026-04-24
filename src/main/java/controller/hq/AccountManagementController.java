package controller.hq;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.AccountDTO;
import dto.hq.hr.BranchOptionDTO;
import service.AccountService;
import service.AccountServiceImpl;
import service.BranchService;
import service.BranchServiceImpl;

/**
 * Servlet implementation class AccountManagementController
 */
@WebServlet("/hq/hr/main")
public class AccountManagementController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private BranchService branchService = new BranchServiceImpl();
	private AccountService accountService = new AccountServiceImpl();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AccountManagementController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			List<BranchOptionDTO> branchNameList = branchService.searchBranchName();
			AccountDTO account = new AccountDTO();
			List<AccountDTO> accountList = accountService.searchAccountList(account);
			Integer totalCnt = accountService.selectAccountCnt();
			Integer activeCnt = accountService.selectAccountActiveCnt();
			Integer inactiveCnt = accountService.selectAccountInactiveCnt();
			
			request.setAttribute("branchNameList", branchNameList);
			request.setAttribute("accountList", accountList);
			request.setAttribute("totalCnt", totalCnt);
			request.setAttribute("activeCnt", activeCnt);
			request.setAttribute("inactiveCnt", inactiveCnt);
			request.getRequestDispatcher("/hq/hr/permissions-account-management.jsp").forward(request, response);
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
