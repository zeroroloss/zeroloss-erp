package dao.hq.delivery;

import dto.hq.delivery.DriverCandidateDto;
import dto.hq.delivery.DriverDto;
import dto.hq.delivery.RegionDto;
import dto.hq.delivery.VehicleDto;

import java.util.List;

public interface DeliveryDao {
    // Driver
    List<DriverDto> getAllDrivers();
    DriverDto getDriverById(int driverId);
    List<DriverCandidateDto> getDriverCandidates();
    void addDriver(DriverDto driver);
    void updateDriver(DriverDto driver);
    void deleteDriver(int driverId);
    int getDispatchedCount(int driverId);

    // Vehicle
    List<VehicleDto> getAllVehicles();
    VehicleDto getVehicleById(int vehicleId);
    void addVehicle(VehicleDto vehicle);
    void updateVehicle(VehicleDto vehicle);
    void deleteVehicle(int vehicleId);
    int getDispatchCountForVehicle(int vehicleId);

    // Common
    List<RegionDto> getAllRegions();
}
