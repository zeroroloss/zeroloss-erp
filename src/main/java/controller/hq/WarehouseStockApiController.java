package controller.hq;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dto.hq.warehouse.WarehouseStockResultDTO;
import dto.hq.warehouse.WarehouseStockSearchDTO;
import service.hq.WarehouseStockService;
import service.hq.WarehouseStockServiceImpl;

@WebServlet("/api/hq/warehouse/stock")
public class WarehouseStockApiController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final WarehouseStockService service;
       
    public WarehouseStockApiController() {
        super();
        service = new WarehouseStockServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        
        try {
            String categoryName = request.getParameter("categoryName");
            String itemName = request.getParameter("itemName");
            String keyword = request.getParameter("keyword");

            System.out.println("[WarehouseStockApiController] 요청 파라미터 - category: " + categoryName 
                + ", item: " + itemName + ", keyword: " + keyword);

            // 파라미터 정규화
            if ("전체".equals(categoryName)) categoryName = null;
            if ("전체".equals(itemName)) itemName = null;
            if (keyword != null) {
                keyword = keyword.trim();
                if (keyword.isEmpty()) keyword = null;
            }

            // 서비스 호출
            List<WarehouseStockResultDTO> list = service.searchList(
                new WarehouseStockSearchDTO(categoryName, itemName, keyword));

            System.out.println("[WarehouseStockApiController] 조회 성공 - 건수: " 
                + (list == null ? 0 : list.size()));

            // 성공 응답
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(new Gson().toJson(list != null ? list : new java.util.ArrayList<>()));

        } catch (IllegalArgumentException e) {
            // 잘못된 요청 파라미터
            System.err.println("[WarehouseStockApiController] 400 Bad Request - " + e.getMessage());
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, 
                "잘못된 요청 파라미터입니다: " + e.getMessage());

        } catch (NullPointerException e) {
            // 필수 데이터 누락
            System.err.println("[WarehouseStockApiController] 400 Bad Request - " + e.getMessage());
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, 
                "필수 데이터가 누락되었습니다.");

        } catch (Exception e) {
            // 기타 서버 에러
            System.err.println("[WarehouseStockApiController] 500 Internal Server Error");
            e.printStackTrace();
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "서버 오류가 발생했습니다: " + e.getMessage());
        }
    }

    /**
     * JSON 형식의 에러 응답 전송
     */
    private void sendErrorResponse(HttpServletResponse response, int statusCode, String errorMessage) 
            throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json; charset=UTF-8");
        
        JsonObject errorObj = new JsonObject();
        errorObj.addProperty("status", "error");
        errorObj.addProperty("statusCode", statusCode);
        errorObj.addProperty("message", errorMessage);
        
        if (statusCode == HttpServletResponse.SC_BAD_REQUEST) {
            errorObj.addProperty("errorType", "BAD_REQUEST");
        } else if (statusCode == HttpServletResponse.SC_INTERNAL_SERVER_ERROR) {
            errorObj.addProperty("errorType", "INTERNAL_SERVER_ERROR");
        }
        
        response.getWriter().write(errorObj.toString());
    }
}