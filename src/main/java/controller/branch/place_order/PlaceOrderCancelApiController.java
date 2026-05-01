package controller.branch.place_order;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import dto.AccountDTO;
import service.branch.place_order.PlaceOrderService;
import service.branch.place_order.PlaceOrderServiceImpl;

@WebServlet("/api/branch/place_order/cancel")
public class PlaceOrderCancelApiController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final PlaceOrderService poService = new PlaceOrderServiceImpl();
	private final Gson gson = new Gson();
       
    public PlaceOrderCancelApiController() {
        super();
        
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		try {
            // 로그인 체크
			HttpSession session = request.getSession(false);
			if (session == null) {
			    write(response, 401, "fail", "로그인이 필요합니다.");
			    return;
			}
			AccountDTO user = (AccountDTO) session.getAttribute("loginUser");
			if (user == null) {
			    write(response, 401, "fail", "로그인이 필요합니다.");
			    return;
			}
            
            // body 파싱
			String raw = read(request);
			if (isEmpty(raw)) {
			    write(response, 400, "fail", "요청 body가 비어있습니다.");
			    return;
			}

			Map<String, Object> body = gson.fromJson(raw, Map.class);
			System.out.println("body = " + body);
			if (body == null) {
			    write(response, 400, "fail", "JSON 파싱 실패");
			    return;
			}
			
			String poNo = body.get("poNo") != null ? String.valueOf(body.get("poNo")) : null;
			System.out.println("poNo = " + poNo);
			String reason = body.get("cancelReason") != null ? String.valueOf(body.get("cancelReason")) : null;
			System.out.println("cancelReason = " + reason);
            if (isEmpty(poNo) || isEmpty(reason)) {
            	write(response, 400, "fail", "요청 데이터가 올바르지 않습니다.");
            	return;
            }
            
            // 발주 취소 처리
            poService.cancelPlaceOrder(poNo, reason);
            write(response, 200, "success", null);
            
		} catch(Exception e) {
			e.printStackTrace();
			write(response, 500, "error", e.getMessage());
		}
	}
	
	// ============
	// 유틸
	// ============
	
	// FE에서 문자열로 넘어온 json 데이터 
	private String read(HttpServletRequest req) throws IOException {
		StringBuilder sb = new StringBuilder();
		try (BufferedReader br = req.getReader()) {
			String line;
			while((line = br.readLine()) != null) 
				sb.append(line);
		}
		return sb.toString();
	}
	
	private boolean isEmpty(String str) {
		return str == null || str.trim().isEmpty();
	}
	private void write(HttpServletResponse response, int status,
	        String result, String message) throws IOException {

	    response.setStatus(status);

	    Map<String, Object> body = new HashMap<>();
	    body.put("status", result);

	    if (message != null) {
	        body.put("message", message);
	    }

	    response.getWriter().write(gson.toJson(body));
	}

}
