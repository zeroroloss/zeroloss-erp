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

import com.google.gson.Gson;

import dto.hq.warehouse.WarehouseOutboundDTO;
import dto.hq.warehouse.WarehouseOutboundDetailDTO;
import service.hq.warehouse.WarehouseOutboundService;
import service.hq.warehouse.WarehouseOutboundServiceImpl;
import util.GsonFactory;

// 목록 조회  - GET /api/hq/warehouse/outbound?branchName=...&startDate=...&endDate=...
// 상세 조회  - GET /api/hq/warehouse/outbound/{outboundId}
@WebServlet("/api/hq/warehouse/outbound/*")
public class WarehouseOutboundApiController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final WarehouseOutboundService outboundService = new WarehouseOutboundServiceImpl();
    private Gson gson = GsonFactory.getGson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

        String pathInfo = request.getPathInfo();

        // [상세 조회] /api/hq/warehouse/outbound/{outboundNo}
        if (pathInfo != null && pathInfo.length() > 1) {
            int outboundNo = Integer.parseInt(pathInfo.substring(1));

            WarehouseOutboundDetailDTO detail = outboundService.findDetailByOutboundNo(outboundNo);
            sendResponse(response, 200, Map.of(
                "status", "success",
                "data",   detail
            ));
            return;
        }

        // [목록 조회] /api/hq/warehouse/outbound?branchName=...&startDate=...&endDate=...
        String branchName = request.getParameter("branchName");
        String startDate  = request.getParameter("startDate");
        String endDate    = request.getParameter("endDate");

        System.out.println("branchName = " + branchName);
        System.out.println("startDate  = " + startDate);
        System.out.println("endDate    = " + endDate);

        // 날짜 기본값 (이번 달 1일 ~ 오늘)
        Date now = new Date();
        Calendar cal = Calendar.getInstance();
        cal.setTime(now);
        cal.set(Calendar.DAY_OF_MONTH, 1);
        String firstDayOfMonth = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
        String today           = new SimpleDateFormat("yyyy-MM-dd").format(now);

        // 파라미터 null / 전체 처리
        if (branchName == null || branchName.equals("전체")) branchName = null;
        if (startDate  == null || startDate.isEmpty())      startDate  = firstDayOfMonth;
        if (endDate    == null || endDate.isEmpty())        endDate    = today;

        try {
            Map<String, String> params = new HashMap<>();
            params.put("branchName", branchName);
            params.put("startDate",  startDate);
            params.put("endDate",    endDate);

            List<WarehouseOutboundDTO> results = outboundService.findOutbounds(params);

            sendResponse(response, 200, Map.of(
                "status", "success",
                "data",   results
            ));

        } catch (Exception e) {
            e.printStackTrace();
            sendResponse(response, 500, Map.of(
                "status",  "error",
                "message", e.getMessage()
            ));
        }
    }

    // 공통 JSON 응답 처리
    private void sendResponse(HttpServletResponse response, int status, Object body)
            throws IOException {
        response.setStatus(status);
        response.getWriter().write(gson.toJson(body));
    }
}