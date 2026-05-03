package controller.hq.delivery;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dto.hq.delivery.DriverDto;
import dto.hq.delivery.VehicleDto;
import exception.DeletionException;
import service.hq.delivery.DeliveryService;
import service.hq.delivery.DeliveryServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/hq/delivery/driver-vehicle-management")
public class DriverVehicleManagementController extends HttpServlet {
    private final DeliveryService deliveryService = new DeliveryServiceImpl();
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if (action == null) {
            req.getRequestDispatcher("/hq/delivery/driver-vehicle-management.jsp").forward(req, resp);
            return;
        }

        Object result = null;
        try {
            switch (action) {
                case "getDrivers":
                    result = deliveryService.getAllDrivers();
                    break;
                case "getVehicles":
                    result = deliveryService.getAllVehicles();
                    break;
                case "getAddDriverFormData":
                    result = deliveryService.getAddDriverFormData();
                    break;
                case "getEditDriverFormData":
                    result = deliveryService.getEditDriverFormData(Integer.parseInt(req.getParameter("driverId")));
                    break;
                case "getAddVehicleFormData":
                    result = deliveryService.getAddVehicleFormData();
                    break;
                case "getEditVehicleFormData":
                    result = deliveryService.getEditVehicleFormData(Integer.parseInt(req.getParameter("vehicleId")));
                    break;
            }
            resp.getWriter().write(gson.toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        Map<String, Object> response = new HashMap<>();
        boolean success = false;
        String message = "";

        try {
            switch (action) {
                case "addDriver":
                    deliveryService.addDriver(gson.fromJson(req.getReader(), DriverDto.class));
                    success = true;
                    break;
                case "updateDriver":
                    deliveryService.updateDriver(gson.fromJson(req.getReader(), DriverDto.class));
                    success = true;
                    break;
                case "deleteDriver":
                    deliveryService.deleteDriver(Integer.parseInt(req.getParameter("driverId")));
                    success = true;
                    break;
                case "addVehicle":
                    deliveryService.addVehicle(gson.fromJson(req.getReader(), VehicleDto.class));
                    success = true;
                    break;
                case "updateVehicle":
                    deliveryService.updateVehicle(gson.fromJson(req.getReader(), VehicleDto.class));
                    success = true;
                    break;
                case "deleteVehicle":
                    deliveryService.deleteVehicle(Integer.parseInt(req.getParameter("vehicleId")));
                    success = true;
                    break;
            }
        } catch (DeletionException e) {
            message = e.getMessage();
        } catch (Exception e) {
            e.printStackTrace();
            message = "작업 중 오류가 발생했습니다.";
        }

        response.put("success", success);
        response.put("message", message);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(response));
    }
}
