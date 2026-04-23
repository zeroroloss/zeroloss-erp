package controller.hq;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

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

    // /hq/warehouse_stock.jsp에서 조회하기 버튼 클릭시 호출된다.
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String categoryName = request.getParameter("categoryName");
		String itemName = request.getParameter("itemName");
		String keyword = request.getParameter("keyword");
		
		categoryName = categoryName == null ? "" : categoryName;
		itemName = itemName == null ? "" : itemName;
		keyword = keyword == null ? "" : keyword;

		// 조회 결과
		List<WarehouseStockResultDTO> result = service.searchList(new WarehouseStockSearchDTO(categoryName, itemName, keyword));

		// response 인코딩을 UTF-8로 설정
        response.setContentType("application/json; charset=UTF-8");
        
        // json으로 변환하여 클라이언트(브라우저)에게 넘긴다
        Gson gson = new Gson();
        response.getWriter().print(gson.toJson(result));
	}

}
