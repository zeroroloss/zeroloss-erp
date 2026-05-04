package controller.branch.inbound;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

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
		
		List<InboundProcessingDTO> inboundsToProcess = service.findInboundsToProcess();
		System.out.println("입고처리 데이터:" + inboundsToProcess);
		String json = gson.toJson(inboundsToProcess);
		
		response.getWriter().write(json);
	}
}