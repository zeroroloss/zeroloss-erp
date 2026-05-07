package controller.hq;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.AccountDTO;
import dto.AccountEmployeeDTO;
import dto.hq.hr.BranchOptionDTO;
import service.AccountService;
import service.AccountServiceImpl;
import service.BranchService;
import service.BranchServiceImpl;

@WebServlet("/hq/hr/main")
public class AccountManagementController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private BranchService branchService = new BranchServiceImpl();
	private AccountService accountService = new AccountServiceImpl();
       
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");

		try {
			if ("checkAvailableEmployee".equals(action)) {
				checkAvailableEmployee(request, response);
				return;
			}

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
	
	private void checkAvailableEmployee(HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		response.setContentType("application/json; charset=UTF-8");

		String empNoStr = request.getParameter("empNo");

		if (empNoStr == null || empNoStr.trim().isEmpty()) {
			response.getWriter().write("{\"success\":false,\"message\":\"사번을 입력해주세요.\"}");
			return;
		}

		int empNo;

		try {
			empNo = Integer.parseInt(empNoStr);
		} catch (NumberFormatException e) {
			response.getWriter().write("{\"success\":false,\"message\":\"사번은 숫자로 입력해주세요.\"}");
			return;
		}

		AccountDTO employeeCheck = accountService.selectEmployeeByEmpNo(empNo);

		if (employeeCheck == null) {
			response.getWriter().write("{\"success\":false,\"message\":\"존재하지 않는 직원입니다.\"}");
			return;
		}

		AccountDTO accountCheck = accountService.selectAccountByEmpNo(empNo);

		if (accountCheck != null) {
			response.getWriter().write("{\"success\":false,\"message\":\"이미 계정이 존재하는 직원입니다.\"}");
			return;
		}

		AccountEmployeeDTO employee = accountService.selectAvailableEmployee(empNo);

		if (employee == null) {
			response.getWriter().write("{\"success\":false,\"message\":\"계정 추가 가능한 직원이 아닙니다.\"}");
			return;
		}

		int roleId = getFixedRoleId(employee);
		String roleName = getFixedRoleName(roleId);

		String branchCodeJson = employee.getBranchCode() == null
				? "null"
				: String.valueOf(employee.getBranchCode());

		String branchName = employee.getBranchName() == null || employee.getBranchName().trim().isEmpty()
				? "-"
				: employee.getBranchName();

		String json = "{"
				+ "\"success\":true,"
				+ "\"empNo\":" + employee.getEmpNo() + ","
				+ "\"name\":\"" + escapeJson(employee.getName()) + "\","
				+ "\"branchCode\":" + branchCodeJson + ","
				+ "\"branchName\":\"" + escapeJson(branchName) + "\","
				+ "\"roleId\":" + roleId + ","
				+ "\"roleName\":\"" + escapeJson(roleName) + "\""
				+ "}";

		response.getWriter().write(json);
	}
	
	private int getFixedRoleId(AccountEmployeeDTO employee) {
		// 본사 인사 직원
		if (employee.getBranchCode() == null && "인사".equals(employee.getDept())) {
			return 1; // 본사 관리자
		}

		// 직영점 점장
		if ("POS_MGR".equals(employee.getPositionCode())) {
			return 2; // 지점장
		}

		// 직영점 매니저
		if ("POS_SUP".equals(employee.getPositionCode())) {
			return 3; // 매니저
		}

		return 0;
	}

	private String getFixedRoleName(int roleId) {
		if (roleId == 1) {
			return "본사 관리자";
		}

		if (roleId == 2) {
			return "지점장";
		}

		if (roleId == 3) {
			return "매니저";
		}

		return "";
	}

	private String escapeJson(String value) {
		if (value == null) {
			return "";
		}

		return value.replace("\\", "\\\\")
				.replace("\"", "\\\"")
				.replace("\n", "\\n")
				.replace("\r", "\\r");
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");	
		String action = request.getParameter("action");
				
		try {
		    if ("add".equals(action)) {
		        addAccount(request, response);
		    } else if ("update".equals(action)) {
		        updateAccount(request, response);
		    } else if ("statusToggle".equals(action)) {
		        toggleAccountStatus(request, response);
		    } else {
		        response.getWriter().write("{\"success\":false,\"message\":\"잘못된 요청입니다.\"}");
		    }
		} catch (NumberFormatException e) {
		    e.printStackTrace();
		    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		    response.getWriter().write("{\"success\":false,\"message\":\"숫자 형식이 올바르지 않습니다.\"}");
		} catch (Exception e) {
		    e.printStackTrace();
		    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		    response.getWriter().write("{\"success\":false,\"message\":\"처리 중 오류가 발생했습니다. 입력값을 확인해주세요.\"}");
		}
	}
	
	private void addAccount(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
		String empNoStr = request.getParameter("empNo");
		String loginId = request.getParameter("loginId");
		String password = request.getParameter("password");
		String status = request.getParameter("status");

		if (empNoStr == null || empNoStr.trim().isEmpty()) {
			response.getWriter().write("{\"success\":false,\"message\":\"사번을 입력해주세요.\"}");
			return;
		}

		int empNo;

		try {
			empNo = Integer.parseInt(empNoStr);
		} catch (NumberFormatException e) {
			response.getWriter().write("{\"success\":false,\"message\":\"사번은 숫자로 입력해주세요.\"}");
			return;
		}

		if (loginId == null || loginId.trim().isEmpty()) {
			response.getWriter().write("{\"success\":false,\"message\":\"아이디를 입력해주세요.\"}");
			return;
		}

		if (password == null || password.trim().isEmpty()) {
			response.getWriter().write("{\"success\":false,\"message\":\"비밀번호를 입력해주세요.\"}");
			return;
		}

		if (status == null || status.trim().isEmpty()) {
			status = "ACTIVE";
		}

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

		// 3. 계정 추가 가능 직원인지 확인
		AccountEmployeeDTO employee = accountService.selectAvailableEmployee(empNo);

		if (employee == null) {
			response.getWriter().write("{\"success\":false,\"message\":\"계정 추가 가능한 직원이 아닙니다.\"}");
			return;
		}

		// 4. 아이디 중복 확인
		AccountDTO existingLoginId = accountService.selectAccountByLoginId(loginId);

		if (existingLoginId != null) {
			response.getWriter().write("{\"success\":false,\"message\":\"이미 사용 중인 아이디입니다.\"}");
			return;
		}

		int fixedRoleId = getFixedRoleId(employee);

		if (fixedRoleId == 0) {
			response.getWriter().write("{\"success\":false,\"message\":\"역할을 자동 지정할 수 없습니다.\"}");
			return;
		}

		AccountDTO account = new AccountDTO();

		account.setEmpNo(empNo);
		account.setLoginId(loginId.trim());
		account.setPassword(password);

		// 핵심: roleId는 request 값 사용 금지, 서버에서 고정
		account.setRoleId(fixedRoleId);

		// 핵심: branchCode도 조회된 직원 정보 기준으로 저장
		// 본사 직원 branchCode가 null이면 AccountDTO가 int인지 Integer인지에 따라 처리 필요
		if (employee.getBranchCode() != null) {
			account.setBranchCode(employee.getBranchCode());
		}

		account.setStatus(status);

		accountService.addAccount(account);

		response.getWriter().write("{\"success\":true,\"message\":\"계정이 추가되었습니다.\"}");
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
	    String status = request.getParameter("status");

	    AccountDTO account = new AccountDTO();
	    account.setAccountId(accountId);
	    account.setRoleId(roleId);
	    account.setBranchCode(branchCode);
	    account.setStatus(status);

	    accountService.modifyAccount(account);

	    response.getWriter().write("{\"success\":true}");
	}
	
}
