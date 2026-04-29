package controller.branch.place_order;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import dto.AccountDTO;
import service.hq.warehouse.WarehouseStockService;
import service.hq.warehouse.WarehouseStockServiceImpl;
import util.GsonFactory;

@WebServlet("/api/branch/place_order/create/items")
public class PlaceOrderCreateItemsApiController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final WarehouseStockService warehouseStockService = new WarehouseStockServiceImpl();
	private final Gson gson = GsonFactory.getGson();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");

		try {
			AccountDTO loginUser = getLoginUser(request);
			if (loginUser == null) {
				sendResponse(response, 401, failBody("로그인이 필요합니다.")); // 401 Unauthorized 
				return;
			}

			// 필터링을 위해, Map을 List로 펼치기
			Map<String, List<String>> categoryMaterialMap = warehouseStockService.getCategoryMaterialMap();
			List<Map<String, String>> materials = new ArrayList<>();
			
			if (categoryMaterialMap != null) {
				for (Map.Entry<String, List<String>> entry : categoryMaterialMap.entrySet()) {
					String category = entry.getKey();
					List<String> itemNames = entry.getValue();
					
					if (itemNames != null) {
						for (String itemName : itemNames) {
							Map<String, String> material = new LinkedHashMap<>();
							material.put("categoryName", category);
							material.put("materialName", itemName);
							material.put("materialCode", itemName);
							material.put("unit", "");
							materials.add(material);
						}
					}
				}
			}

			// 필터링
			String categoryFilter = request.getParameter("category");
			String itemFilter = request.getParameter("item");
			String searchFilter = request.getParameter("search");

			List<Map<String, String>> filteredMaterials = filterMaterials(materials, categoryFilter, itemFilter, searchFilter);
			System.out.println(filteredMaterials);
			sendResponse(response, 200, successBody(filteredMaterials)); // 200 OK

		} catch (Exception e) {
			e.printStackTrace();
			sendResponse(response, 500, errorBody(e.getMessage())); // 500 Internal Server Error
		}
	}

	private List<Map<String, String>> filterMaterials(List<Map<String, String>> materials, String category, String item, String search) {
		List<Map<String, String>> result = new ArrayList<>();
		String searchLower = search != null ? search.toLowerCase() : "";
		
		for (Map<String, String> material : materials) {
			boolean match = true;
			
			String matCategory = material.get("categoryName") != null ? material.get("categoryName") : "";
			String matName = material.get("materialName") != null ? material.get("materialName") : "";
			String matCode = material.get("materialCode") != null ? material.get("materialCode") : "";
			
			// Category filter
			if (category != null && !category.isEmpty() && !"전체".equals(category)) {
				if (!matCategory.equals(category)) {
					match = false;
				}
			}
			
			// Item filter
			if (item != null && !item.isEmpty() && !"전체".equals(item)) {
				if (!matName.equals(item)) {
					match = false;
				}
			}
			
			// Search filter
			if (searchLower.length() > 0) {
				if (!matCode.toLowerCase().contains(searchLower) &&
					!matName.toLowerCase().contains(searchLower) &&
					!matCategory.toLowerCase().contains(searchLower)) {
					match = false;
				}
			}
			
			if (match) {
				result.add(material);
			}
		}
		
		return result;
	}

	private int resolveBranchCode(AccountDTO loginUser) {
		if (loginUser == null) {
			return 1; // Default branch
		}
		Integer branchCode = loginUser.getBranchCode();
		return branchCode != null ? branchCode : 1;
	}

	private boolean hasText(String value) {
		return value != null && !value.trim().isEmpty();
	}

	private Map<String, Object> successBody(Object data) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put("status", "success");
		body.put("data", data);
		return body;
	}

	private Map<String, Object> failBody(String message) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put("status", "fail");
		body.put("message", message);
		return body;
	}

	private Map<String, Object> errorBody(String message) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put("status", "error");
		body.put("message", hasText(message) ? message : "서버 처리 중 오류가 발생했습니다.");
		return body;
	}

	private AccountDTO getLoginUser(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session == null) {
			return null;
		}
		return (AccountDTO) session.getAttribute("loginUser");
	}

	private void sendResponse(HttpServletResponse response, int status, Object body) throws IOException {
		response.setStatus(status);
		response.setContentType("application/json; charset=UTF-8");
		response.getWriter().write(gson.toJson(body));
	}
}

