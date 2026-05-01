package controller.branch.place_order;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import dto.AccountDTO;
import service.branch.place_order.PlaceOrderSendService;
import service.branch.place_order.PlaceOrderSendServiceImpl;
import util.GsonFactory;

@WebServlet("/branch/place_order/send")
public class PlaceOrderDraftSendController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final PlaceOrderSendService service = new PlaceOrderSendServiceImpl();
    private final Gson gson = GsonFactory.getGson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
        	
            HttpSession session = request.getSession(false);
            if (session == null) {
                sendResponse(response, 401, failBody("로그인이 필요합니다.")); // 401 Unauthorized
                return;
            }
            
            AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");
            if (loginUser == null) {
                sendResponse(response, 401, failBody("로그인이 필요합니다.")); // 401 Unauthorized
                return;
            }

            // 발주서 전송
            boolean sendSuccess = service.sendDraft(loginUser.getBranchCode());
            if (!sendSuccess) {
                sendResponse(response, 500, errorBody("전송 처리에 실패했습니다.")); // 500 Internal Server Error
                return;
            }

            sendResponse(response, 200, successBody(null)); // 200 OK
        } catch (Exception e) {
            e.printStackTrace();
            sendResponse(response, 500, errorBody(e.getMessage())); // 500 Internal Server Error
        }
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
        body.put("message", message == null ? "서버 처리 중 오류가 발생했습니다." : message);
        return body;
    }

    private void sendResponse(HttpServletResponse response, int status, Object body) throws IOException {
        response.setStatus(status);
        response.getWriter().write(gson.toJson(body));
    }
}