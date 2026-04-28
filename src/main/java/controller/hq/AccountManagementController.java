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
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");	
		String action = request.getParameter("action");
				
		try {
			if("add".equals(action)) {
				addAccount(request, response);
			} else if ("update".equals(action)) {
				updateAccount(request, response);
			} else if ("statusToggle".equals(action)) {
				toggleAccountStatus(request, response);
			} else {
				response.getWriter().write("{\"success\":false,\"message\":\"잘못된 요청입니다.\"}");
			}
		} catch(Exception e) {
			e.printStackTrace();
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        response.getWriter().write("{\"success\":false,\"message\":\"서버 오류\"}");
		}
	}
	
	private void addAccount(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
		String empNoStr = request.getParameter("empNo");

	    if (empNoStr == null || empNoStr.trim().isEmpty()) {
	        response.getWriter().write("{\"success\":false,\"message\":\"사번을 입력해주세요.\"}");
	        return;
	    }

	    int empNo = Integer.parseInt(empNoStr);

	    // 1. 존재하지 않는 직원인지 확인
	    AccountDTO employeeCheck = accountService.selectEmployeeByEmpNo(empNo);

	    if (employeeCheck == null) {
	        response.getWriter().write("{\"success\":false,\"message\":\"존재하지 않는 직원입니다.\"}");
	        return;
	    }

	    // 2. 이미 계정이 있는 직원인지 확인
	    AccountDTO accountCheck = accountService.selectAccountByEmpNo(empNo);

	    if (accountCheck != null) {
	        response.getWriter().write("{\"success\":false,\"message\":\"이미 계정이 존재하는 직원입니다.\"}");
	        return;
	    }

        AccountDTO account = new AccountDTO();

        account.setEmpNo(Integer.parseInt(request.getParameter("empNo")));
        account.setLoginId(request.getParameter("loginId"));
        account.setPassword(request.getParameter("password"));
        account.setBranchCode(Integer.parseInt(request.getParameter("branchCode")));
        account.setRoleId(Integer.parseInt(request.getParameter("roleId")));
        account.setStatus(request.getParameter("status"));

        accountService.addAccount(account);

        response.getWriter().write("{\"success\":true}");
    }
	
	private void toggleAccountStatus(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		int accountId = Integer.parseInt(request.getParameter("accountId"));
		accountService.toggleAccountStatus(accountId);
		response.getWriter().write("{\"success\":true}");
	}

	private void updateAccount(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
		int accountId = Integer.parseInt(request.getParameter("accountId"));
	    int roleId = Integer.parseInt(request.getParameter("roleId"));
	    int branchCode = Integer.parseInt(request.getParameter("branchCode"));

	    AccountDTO account = new AccountDTO();
	    account.setAccountId(accountId);
	    account.setRoleId(roleId);
	    account.setBranchCode(branchCode);

	    accountService.modifyAccount(account);

	    response.getWriter().write("{\"success\":true}");
	}
	
}
