package controller.hq.place_order;

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

import dto.hq.place_order.PlaceOrderOverviewDTO;
import dto.hq.place_order.PlaceOrderOverviewDetailDTO;
import service.hq.place_order.PlaceOrderOverviewService;
import service.hq.place_order.PlaceOrderOverviewServiceImpl;
import util.GsonFactory;

// 조회하기  - /api/hq/place_order/overview?branchName=...&startDate=...
// 상세 조회 - /api/hq/place_order/overview/{poId}

@WebServlet("/api/hq/place_order/overview/*")
public class PlaceOrderOverviewApiController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final PlaceOrderOverviewService overviewService = new PlaceOrderOverviewServiceImpl();
	private Gson gson = GsonFactory.getGson();
       
    public PlaceOrderOverviewApiController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        
        String pathInfo = request.getPathInfo();
        
        // [상세조회]
        if (pathInfo != null && pathInfo.length() > 1) {
        	int poId = Integer.parseInt(pathInfo.substring(1)); // '/' 이후부터 가져옴
        	
        	// 상세 서비스 호출
        	PlaceOrderOverviewDetailDTO detail = overviewService.findDetailByPoId(poId);

            sendResponse(response, 200, Map.of(
                "status", "success",
                "data", detail
            ));

            return;
        }
        
        // [조회하기]
        String branchName 	= request.getParameter("branchName");
        String startDate    = request.getParameter("startDate");
        String endDate      = request.getParameter("endDate");
        System.out.println("branchName = " + branchName);
        System.out.println("startDate = " + startDate);
        System.out.println("endDate = " + endDate);
        // 오늘 날짜
        Date now = new Date();
        // 이번 달 1일 구하기
        Calendar cal = Calendar.getInstance();
        cal.setTime(now);
        cal.set(Calendar.DAY_OF_MONTH, 1);

        String firstDayOfMonth = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
        String today = new SimpleDateFormat("yyyy-MM-dd").format(now);
        // 파라미터 null 처리
        if (branchName == null || branchName.equals("전체")) branchName = null; // null이면 테이블에서 다 가져옴 where로 거르지 않음
        if (startDate == null || startDate.isEmpty()) startDate = firstDayOfMonth;
        if (endDate   == null || endDate.isEmpty())   endDate   = today;

        try {
        	Map<String, String> params = new HashMap<>();
        	params.put("branchName", branchName);
        	params.put("startDate", startDate);
        	params.put("endDate", endDate);
        	
        	List<PlaceOrderOverviewDTO> results = overviewService.findPlaceOrders(params);
        	
        	sendResponse(response, 200, Map.of(
        		"status", "success",
        		"data", results
			));
        	
        } catch(Exception e) {
            e.printStackTrace();
            sendResponse(response, 500, Map.of(
                "status", "error",
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
