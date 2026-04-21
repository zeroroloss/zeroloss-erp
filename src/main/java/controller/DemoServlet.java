package controller;

import config.DemoConfig;
import dto.DemoDto;
import service.DemoService;
import util.DemoJsonUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/demo")
public class DemoServlet extends HttpServlet {
    private final DemoService demoService = new DemoService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        List<DemoDto> data = demoService.getDemoList();

        Map<String, Object> payload = new HashMap<>();
        payload.put("title", DemoConfig.DEMO_TITLE);
        payload.put("count", data.size());
        payload.put("items", data);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(DemoJsonUtil.toJson(payload));
    }
}

