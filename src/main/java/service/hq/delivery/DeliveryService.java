package service.hq.delivery;

import dto.hq.delivery.DriverDto;
import dto.hq.delivery.VehicleDto;

import java.util.List;
import java.util.Map;

public interface DeliveryService {
    // Driver
    List<DriverDto> getAllDrivers();
    Map<String, Object> getAddDriverFormData();
    void addDriver(DriverDto driver);
    Map<String, Object> getEditDriverFormData(int driverId);
    void updateDriver(DriverDto driver);
    void deleteDriver(int driverId);

    // Vehicle
    List<VehicleDto> getAllVehicles();
    Map<String, Object> getAddVehicleFormData();
    void addVehicle(VehicleDto vehicle);
    Map<String, Object> getEditVehicleFormData(int vehicleId);
    void updateVehicle(VehicleDto vehicle);
    void deleteVehicle(int vehicleId);
}
