package controller.hq.warehouse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dto.hq.warehouse.DisposalRequestDTO;
import dto.hq.warehouse.ExpiryItemDTO;
import dto.hq.warehouse.ExpirySearchDTO;

import service.hq.warehouse.WarehouseStockService;
import service.hq.warehouse.WarehouseStockServiceImpl;


/**
 * 유통기한 조회 API 처리
 * GET /api/hq/warehouse/expiry_date - 유통기한 임박 품목 조회
 * POST /api/hq/warehouse/expiry_date/dispose - 폐기 처리
 */
@WebServlet("/api/hq/warehouse/expiry_date/*")
public class WarehouseExpiryDateApiController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final WarehouseStockService service;
	private final Gson gson = new Gson();

	public WarehouseExpiryDateApiController() {
		service = new WarehouseStockServiceImpl();
	}

    // GET /api/hq/warehouse/expiry_date - 조회하기 버튼 - 유통기한 임박 품목 조회
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String category = request.getParameter("category");
		String itemName = request.getParameter("itemName");
		String search = request.getParameter("search");

		if (category == null || category.equals("전체")) category = null;
		if (itemName == null || itemName.equals("전체")) itemName = null;
		if (search == null) search = null;

		try {
			ExpirySearchDTO searchDTO = new ExpirySearchDTO(category, itemName, search);
			List<ExpiryItemDTO> data = service.findExpiryItems(searchDTO);
			if (data == null) {
				data = new java.util.ArrayList<>();
			}

			Map<String, Object> result = new HashMap<>();
			result.put("status", "success");
			result.put("data", data);
			sendResponse(response, 200, result);

		} catch (Exception e) {
			e.printStackTrace();
			Map<String, Object> err = new HashMap<>();
			err.put("status", "error");
			err.put("message", e.getMessage());
			sendResponse(response, 500, err);
		}
	}

    // POST /api/hq/warehouse/expiry_date/dispose - 폐기 처리 버튼
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		try {
			DisposalRequestDTO dto = gson.fromJson(request.getReader(), DisposalRequestDTO.class);

			if (dto == null || dto.getStockNos() == null || dto.getStockNos().isEmpty()) {
				throw new IllegalArgumentException("폐기 대상 재고가 없습니다.");
			}

			boolean result = service.processDisposal(dto.getStockNos());

			Map<String, Object> responseMap = new HashMap<>();
			if (result) {
				responseMap.put("status", "success");
				responseMap.put("message", dto.getStockNos().size() + "개 품목 폐기 처리 완료");
				sendResponse(response, 200, responseMap);
			} else {
				responseMap.put("status", "fail");
				responseMap.put("message", "폐기 처리 실패");
				sendResponse(response, 400, responseMap);
			}

		} catch (Exception e) {
			e.printStackTrace();
			Map<String, Object> err = new HashMap<>();
			err.put("status", "error");
			err.put("message", e.getMessage());
			sendResponse(response, 500, err);
		}
	}

	private void sendResponse(HttpServletResponse response, int status, Object body)
			throws IOException {
		response.setStatus(status);
		response.setContentType("application/json; charset=UTF-8");
		response.getWriter().write(gson.toJson(body));
	}
}