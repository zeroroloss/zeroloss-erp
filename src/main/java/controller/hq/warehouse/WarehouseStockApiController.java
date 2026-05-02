package controller.hq.warehouse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dto.hq.warehouse.WarehouseStockDetailDTO;
import dto.hq.warehouse.WarehouseStockListDTO;
import dto.hq.warehouse.WarehouseStockSearchDTO;
import service.hq.warehouse.WarehouseStockService;
import service.hq.warehouse.WarehouseStockServiceImpl;

// /api/hq/warehouse/stock?...        // 재고 리스트 조회
// /api/hq/warehouse/stock/{stockNo}  // 특정 재고 상세 조회
@WebServlet("/api/hq/warehouse/stock/*")
public class WarehouseStockApiController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final WarehouseStockService service;
    private final Gson gson = new Gson();

    public WarehouseStockApiController() {
        super();
        service = new WarehouseStockServiceImpl();
    }

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

        try {

            String pathInfo = request.getPathInfo();

            /* =========================
               1. 상세 조회 (stockNo)
               /api/hq/warehouse/stock/{stockNo}
            ========================== */
            if (pathInfo != null && pathInfo.length() > 1) {

                String stockNo = pathInfo.substring(1);

                WarehouseStockDetailDTO detail = service.findStockDetailByStockNo(stockNo);
                if (detail == null) {
                    sendResponse(response, 404, Map.of(
                            "status", "error",
                            "message", "해당 재고가 없습니다"
                    ));
                    return;
                }

                sendResponse(response, 200, Map.of(
                        "status", "success",
                        "data", detail
                ));
                return;
            }

            /* =========================
               2. 리스트 조회
               /api/hq/warehouse/stock?categoryName=...
            ========================== */
            String categoryName = request.getParameter("categoryName");
            String itemName = request.getParameter("itemName");
            String keyword = request.getParameter("keyword");

            // 파라미터 정규화
            if ("전체".equals(categoryName)) categoryName = null;
            if ("전체".equals(itemName)) itemName = null;

            if (keyword != null) {
                keyword = keyword.trim();
                if (keyword.isEmpty()) keyword = null;
            }

            WarehouseStockSearchDTO searchDTO = new WarehouseStockSearchDTO();
            searchDTO.setCategoryName(categoryName);
            searchDTO.setItemName(itemName);
            searchDTO.setKeyword(keyword);
            List<WarehouseStockListDTO> list = service.searchList(searchDTO);

            sendResponse(response, 200, Map.of(
	        	    "status", "success",
	        	    "data", list != null ? list : new ArrayList<>()
	        	));

        } catch (IllegalArgumentException e) {
        	e.printStackTrace();
            sendResponse(response, 400, Map.of(
                    "status", "error",
                    "message", "잘못된 요청입니다: " + e.getMessage()
            ));

        } catch (NullPointerException e) {
        	e.printStackTrace();
            sendResponse(response, 400, Map.of(
                    "status", "error",
                    "message", "필수 데이터 누락"
            ));

        } catch (Exception e) {

            e.printStackTrace();

            sendResponse(response, 500, Map.of(
                    "status", "error",
                    "message", "서버 오류: " + e.getMessage()
            ));
        }
    }

    // 공통 JSON 응답 처리
    private void sendResponse(HttpServletResponse response, int status, Object body)
            throws IOException {

        response.setStatus(status);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(gson.toJson(body));
    }
}