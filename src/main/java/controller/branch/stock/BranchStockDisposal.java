package controller.branch.stock;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.AccountDTO;
import dto.BranchStockChangeHistoryDTO;
import dto.BranchStockDisposalHistoryDTO;
import service.branch.stock.BranchDisposalService;
import service.branch.stock.BranchDisposalServiceImpl;
import service.branch.stock.BranchStockAlertService;
import service.branch.stock.BranchStockAlertServiceImpl;

@WebServlet("/branch/stock/disposal")
public class BranchStockDisposal extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 response.setContentType("application/json;charset=UTF-8");

	        try {
	            AccountDTO loginUser = getLoginUser(request);
	            if (loginUser == null) {
	                response.setStatus(401);
	                return;
	            }
	            String branchStockCode = request.getParameter("branchStockCode");
	            
	            // 요청 파라미터
	            BigDecimal disposalQty = new BigDecimal(request.getParameter("disposalQty"));
	            String reason          = request.getParameter("disposalReason");
	            String reasonDetail    = request.getParameter("reasonDetail");

	            BranchDisposalService branchDisposalService = new BranchDisposalServiceImpl();

	            // 1. 현재 수량 조회
	            BigDecimal currentQty = branchDisposalService.selectCurrentQty(branchStockCode);
	            if (currentQty == null) {
	                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	                response.getWriter().write("{\"error\":\"존재하지 않는 재고입니다.\"}");
	                return;
	            }

	            // 2. 폐기 수량 검증
	            if (disposalQty.compareTo(currentQty) > 0) {
	                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	                response.getWriter().write("{\"error\":\"폐기 수량이 현재 수량보다 많습니다.\"}");
	                return;
	            }

	            BigDecimal afterQty = currentQty.subtract(disposalQty);

	            // 3. branch_stock_change_history
	            BranchStockChangeHistoryDTO changeHistory = new BranchStockChangeHistoryDTO();
	            changeHistory.setBranchStockCode(branchStockCode);
	            changeHistory.setChangeAmount(disposalQty.negate());
	            changeHistory.setChangeType("DISPOSAL");
	            changeHistory.setAfterQty(afterQty);
	            branchDisposalService.insertStockChangeHistory(changeHistory);

	            // 4. branch_stock_disposal_history
	            BranchStockDisposalHistoryDTO disposalHistory = new BranchStockDisposalHistoryDTO();
	            disposalHistory.setChangeId(changeHistory.getChangeId());
	            disposalHistory.setReason(reason);
	            disposalHistory.setReasonDetail(reasonDetail);
	            branchDisposalService.insertDisposalHistory(disposalHistory);

	            // 5. branch_stock 수량 차감
	            Map<String, Object> params = new HashMap<>();
	            params.put("branchStockCode", branchStockCode);
	            params.put("disposalQty",     disposalQty);
	            int updated = branchDisposalService.updateBranchStockQty(params);

	            if (updated == 0) {
	                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	                response.getWriter().write("{\"error\":\"재고 수량 차감에 실패했습니다.\"}");
	                return;
	            }
	         // 6. 재고 알림 체크
	            BranchStockAlertService branchStockAlertService = new BranchStockAlertServiceImpl();
	            branchStockAlertService.sendStockAlerts(loginUser.getBranchCode(), loginUser.getAccountId());

	            response.getWriter().write("{\"success\":true}");

	        } catch (Exception e) {
	            e.printStackTrace();
	            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	            response.getWriter().write("{\"error\":\"서버 오류가 발생했습니다.\"}");
	        }
	    }

	    private AccountDTO getLoginUser(HttpServletRequest request) {
	        HttpSession session = request.getSession(false);
	        if (session == null) return null;
	        return (AccountDTO) session.getAttribute("loginUser");
	    }

}
