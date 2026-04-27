package controller.branch.sales;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
import dto.AccountDTO;
import dto.branch.sales.DailySalesDTO;
import service.branch.sales.SalesService;
import service.branch.sales.SalesServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/branch/sales/daily")
public class DailySalesController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final SalesService salesService = new SalesServiceImpl();

    // LocalDate를 JSON으로 변환할 때 "yyyy-MM-dd" 형식으로 직렬화하기 위한 Gson 설정
    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new TypeAdapter<LocalDate>() {
                @Override
                public void write(JsonWriter out, LocalDate value) throws IOException {
                    out.value(value != null ? value.format(DateTimeFormatter.ISO_LOCAL_DATE) : null);
                }
                @Override
                public LocalDate read(JsonReader in) throws IOException {
                    return LocalDate.parse(in.nextString());
                }
            }).create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");

        // 🟢 임시 로그인 제거: 세션에 유저 정보가 없으면 401 에러 반환
        if (loginUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\": \"로그인 세션이 만료되었습니다. 다시 로그인해주세요.\"}");
            return;
        }

        try {
            // URL 파라미터에서 날짜 가져오기 (예: ?date=2026-04-27)
            String dateParam = request.getParameter("date");
            LocalDate targetDate;

            if (dateParam == null || dateParam.isEmpty()) {
                targetDate = LocalDate.now(); // 날짜 미지정 시 오늘 기준
            } else {
                targetDate = LocalDate.parse(dateParam);
            }

            // 🟢 현재 로그인된 지점의 코드를 사용하여 데이터 조회
            int branchCode = loginUser.getBranchCode();
            List<DailySalesDTO> dailySales = salesService.getDailySales(branchCode, targetDate);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(dailySales));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\": \"매출 데이터를 조회하는 중 서버 오류가 발생했습니다.\"}");
        }
    }
}