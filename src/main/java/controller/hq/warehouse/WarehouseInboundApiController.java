package controller.hq.warehouse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.hq.warehouse.InboundRecordDTO;
import dto.hq.warehouse.InboundRequestDTO;
import dto.hq.warehouse.InboundSearchDTO;
import service.hq.warehouse.WarehouseStockService;
import service.hq.warehouse.WarehouseStockServiceImpl;

@WebServlet("/api/hq/warehouse/inbound")
public class WarehouseInboundApiController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	private final WarehouseStockService service = new WarehouseStockServiceImpl();

    // 입고 이력 조회
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String supplierName = request.getParameter("supplier");
        String categoryName = request.getParameter("categoryName");
        String itemName     = request.getParameter("itemName");
        String startDate    = request.getParameter("startDate");
        String endDate      = request.getParameter("endDate");

        // null 방어
        if (supplierName == null) supplierName = "전체";
        if (categoryName == null) categoryName = "전체";
        if (itemName     == null) itemName     = "전체";

        // 오늘 날짜
        Date now = new Date();
        // 이번 달 1일 구하기
        Calendar cal = Calendar.getInstance();
        cal.setTime(now);
        cal.set(Calendar.DAY_OF_MONTH, 1);

        String firstDayOfMonth = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
        String today = new SimpleDateFormat("yyyy-MM-dd").format(now);
        if (startDate == null || startDate.isEmpty()) startDate = firstDayOfMonth;
        if (endDate   == null || endDate.isEmpty())   endDate   = today;


        try {
        	InboundSearchDTO searchDTO = new InboundSearchDTO();
        	searchDTO.setSupplierName(supplierName);
        	searchDTO.setCategoryName(categoryName);
        	searchDTO.setItemName(itemName);
        	searchDTO.setStartDate(startDate);
        	searchDTO.setEndDate(endDate);
        	
            List<InboundRecordDTO> data = service.findInboundRecords(searchDTO);

            Map<String, Object> result = new HashMap<>();
            result.put("status", "success");
            result.put("data",   data);
            sendResponse(response, 200, result);

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> err = new HashMap<>();
            err.put("status",  "error");
            err.put("message", e.getMessage());
            sendResponse(response, 500, err);
        }
    }

    // 신규 입고 등록
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            InboundRequestDTO dto = util.GsonFactory.getGson().fromJson(request.getReader(), InboundRequestDTO.class);
            if (dto == null) {
                throw new IllegalArgumentException("요청 데이터가 비어있습니다.");
            }
            boolean ok = service.processInbound(dto);

            Map<String, Object> result = new HashMap<>();
            if (ok) {
                result.put("status", "success");
                sendResponse(response, 200, result);
            } else {
                result.put("status", "fail");
                result.put("message", "입고 처리 실패");
                sendResponse(response, 400, result);
            }

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> err = new HashMap<>();
            err.put("status",  "error");
            err.put("message", e.getMessage());
            sendResponse(response, 500, err);
        }
    }

    private void sendResponse(HttpServletResponse response, int status, Object body)
            throws IOException {
        response.setStatus(status);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(util.GsonFactory.getGson().toJson(body));
    }
}
