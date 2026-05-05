package controller.branch.inbound;

import java.io.IOException;
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
import dto.branch.inbound.InboundProcessingItemDTO;
import dto.branch.inbound.InboundProcessingDTO;
import service.branch.inbound.InboundService;
import service.branch.inbound.InboundServiceImpl;

@WebServlet("/api/branch/inbound/processing")
public class InboundProcessingApiController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final InboundService service = new InboundServiceImpl();
	private final Gson gson = util.GsonFactory.getGson();

    public InboundProcessingApiController() {
        super();
    }

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		AccountDTO loginUser = getLoginUser(request);
		if (loginUser == null) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			response.getWriter().write(gson.toJson(failBody("로그인이 필요합니다.")));
			return;
		}
		
		// DELIVERED 상태의 발주들 가져오기
		List<InboundProcessingDTO> inboundsToProcess = service.findInboundsToProcess(loginUser.getBranchCode());
		System.out.println("입고처리 데이터:" + inboundsToProcess);
		String json = gson.toJson(inboundsToProcess);
		
		response.getWriter().write(json);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		AccountDTO loginUser = getLoginUser(request);
		if (loginUser == null) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			response.getWriter().write(gson.toJson(failBody("로그인이 필요합니다.")));
			return;
		}

		try {
			Map<?, ?> body = gson.fromJson(request.getReader(), Map.class);
			String poNo = body == null || body.get("poNo") == null ? null : String.valueOf(body.get("poNo"));
			
			List<InboundProcessingItemDTO> items = InboundProcessingItemDTO.from(body == null ? null : body.get("items"));

			// 입고 처리
			boolean success = service.confirmInbound(loginUser.getBranchCode(), poNo, items);
			
			if (!success) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write(gson.toJson(failBody("입고 확정에 실패했습니다.")));
				return;
			}

			response.setStatus(HttpServletResponse.SC_OK);
			response.getWriter().write(gson.toJson(successBody("입고 확정이 완료되었습니다.")));
		} catch (IllegalArgumentException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write(gson.toJson(failBody(e.getMessage())));
		} catch (IllegalStateException e) {
			response.setStatus(HttpServletResponse.SC_CONFLICT);
			response.getWriter().write(gson.toJson(failBody(e.getMessage())));
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write(gson.toJson(failBody("서버 오류가 발생했습니다.")));
		}
	}

	private AccountDTO getLoginUser(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session == null) {
			return null;
		}
		return (AccountDTO) session.getAttribute("loginUser");
	}

	private Map<String, Object> successBody(String message) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put("status", "success");
		body.put("message", message);
		return body;
	}

	private Map<String, Object> failBody(String message) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put("status", "fail");
		body.put("message", message == null ? "요청 처리에 실패했습니다." : message);
		return body;
	}
}