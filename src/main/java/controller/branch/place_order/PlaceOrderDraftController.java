package controller.branch.place_order;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.AccountDTO;
import dto.MaterialDTO;
import dto.MaterialGroupDTO;
import dto.branch.place_order.PlaceOrderDraftDTO;
import service.branch.place_order.PlaceOrderService;
import service.branch.place_order.PlaceOrderServiceImpl;

@WebServlet("/branch/place_order/draft")
public class PlaceOrderDraftController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final PlaceOrderService service = new PlaceOrderServiceImpl();

	public PlaceOrderDraftController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8"); // 화면 내려줌
		
		try {
			AccountDTO loginUser = getLoginUser(request);
			if (loginUser == null) {
				response.setStatus(401); // 401 Unauthorized
				return;
			}
			
			int branchCode = loginUser.getBranchCode();
			
			// draft 조회 (없으면 생성)
			// 현재 지점에 임시저장된(IN_PROGRESS 상태)인 '지점 발주 임시 저장(place_order_draft)'이 있으면 가져오고 없으면 추가한다.
			// 안전재고 미달 품목이 있는지 확인 후 draft Details에 없으면 추가한다.
			// 반환: draftDTO
			PlaceOrderDraftDTO draftDTO = service.findOrCreateInProgressDraft(branchCode);
			
			// 전체 미달 품목 개수
			int lowStockTotalCount = service.getLowStockTotalCount(branchCode);

			List<MaterialGroupDTO> categoryList = service.getSelectableCategories(branchCode);
			Map<String, List<String>> categoryMaterialMap = new LinkedHashMap<>();
			if (categoryList != null) {
				for (MaterialGroupDTO category : categoryList) {
					if (category == null || category.getMaterialGroupId() == null || category.getGroupName() == null) {
						continue;
					}

					List<MaterialDTO> materialList = service.getSelectableMaterials(category.getMaterialGroupId());
					categoryMaterialMap.put(category.getGroupName(), new java.util.ArrayList<>());
					if (materialList == null) {
						continue;
					}

					for (MaterialDTO material : materialList) {
						if (material != null && material.getMaterialName() != null) {
							categoryMaterialMap.get(category.getGroupName()).add(material.getMaterialName());
						}
					}
				}
			}
			
			// 응답 - 페이지 전송
            request.setAttribute("draft", draftDTO);
            request.setAttribute("lowStockTotalCount", lowStockTotalCount);
			request.setAttribute("categoryMaterialMap", categoryMaterialMap);
			request.getRequestDispatcher("/branch/place_order/create.jsp").forward(request, response);
			
		} catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500); // Internal Server Error
            response.getWriter().write("server error");
        }
	}
	

	private AccountDTO getLoginUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (AccountDTO) session.getAttribute("loginUser");
    }

}
