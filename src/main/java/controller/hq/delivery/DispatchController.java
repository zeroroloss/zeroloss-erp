package controller.hq.delivery;

import com.google.gson.Gson;
import dto.hq.delivery.DispatchCreationDto;
import service.hq.delivery.DispatchService;
import service.hq.delivery.DispatchServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/hq/delivery/dispatch")
public class DispatchController extends HttpServlet {
    private final DispatchService dispatchService = new DispatchServiceImpl();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        Object result = null;
        try {
            if (action == null || action.isEmpty()) {
                req.getRequestDispatcher("/hq/delivery/dispatch-management.jsp").forward(req, resp);
                return;
            }
            
            switch (action) {
                case "getPageData":
                    result = dispatchService.getDispatchPageData();
                    break;
                case "getOrderDetails":
                    String poNo = req.getParameter("poNo");
                    result = dispatchService.getOrderDetails(poNo);
                    break;
                case "getModalData":
                    String regionCode = req.getParameter("regionCode");
                    result = dispatchService.getDispatchModalData(regionCode);
                    break;
                default:
                     resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                     return;
            }
            resp.getWriter().write(gson.toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing GET request");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        Map<String, Object> response = new HashMap<>();
        boolean success = false;
        String message = "";

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            // Content-Type이 application/json인 경우
            String contentType = req.getContentType();
            if (contentType != null && contentType.contains("application/json")) {
                DispatchCreationDto dto = gson.fromJson(req.getReader(), DispatchCreationDto.class);
                dispatchService.createDispatch(dto);
                success = true;
                message = "배차가 생성되었습니다.";
            } else if ("createDispatch".equals(action)) {
                DispatchCreationDto dto = gson.fromJson(req.getReader(), DispatchCreationDto.class);
                dispatchService.createDispatch(dto);
                success = true;
                message = "배차가 생성되었습니다.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "배차 생성 중 오류가 발생했습니다: " + e.getMessage();
        }

        response.put("success", success);
        response.put("message", message);
        resp.getWriter().write(gson.toJson(response));
    }
}
