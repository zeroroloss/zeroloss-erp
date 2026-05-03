package service.hq.delivery;

import dao.hq.delivery.DeliveryDao;
import dao.hq.delivery.DeliveryDaoImpl;
import dto.hq.delivery.DriverDto;
import dto.hq.delivery.VehicleDto;
import exception.DeletionException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DeliveryServiceImpl implements DeliveryService {
    private final DeliveryDao deliveryDao = new DeliveryDaoImpl();

    // Driver methods
    @Override
    public List<DriverDto> getAllDrivers() {
        return deliveryDao.getAllDrivers();
    }
    @Override
    public Map<String, Object> getAddDriverFormData() {
        Map<String, Object> formData = new HashMap<>();
        formData.put("candidates", deliveryDao.getDriverCandidates());
        formData.put("regions", deliveryDao.getAllRegions());
        return formData;
    }
    @Override
    public void addDriver(DriverDto driver) {
        deliveryDao.addDriver(driver);
    }
    @Override
    public Map<String, Object> getEditDriverFormData(int driverId) {
        Map<String, Object> formData = new HashMap<>();
        formData.put("driver", deliveryDao.getDriverById(driverId));
        formData.put("regions", deliveryDao.getAllRegions());
        return formData;
    }
    @Override
    public void updateDriver(DriverDto driver) {
        deliveryDao.updateDriver(driver);
    }
    @Override
    public void deleteDriver(int driverId) {
        if (deliveryDao.getDispatchedCount(driverId) > 0) {
            throw new DeletionException("해당 기사에게 배정된 배차 내역이 있어 삭제할 수 없습니다.");
        }
        deliveryDao.deleteDriver(driverId);
    }

    // Vehicle methods
    @Override
    public List<VehicleDto> getAllVehicles() {
        return deliveryDao.getAllVehicles();
    }
    @Override
    public Map<String, Object> getAddVehicleFormData() {
        Map<String, Object> formData = new HashMap<>();
        formData.put("regions", deliveryDao.getAllRegions());
        return formData;
    }
    @Override
    public void addVehicle(VehicleDto vehicle) {
        deliveryDao.addVehicle(vehicle);
    }
    @Override
    public Map<String, Object> getEditVehicleFormData(int vehicleId) {
        Map<String, Object> formData = new HashMap<>();
        formData.put("vehicle", deliveryDao.getVehicleById(vehicleId));
        formData.put("regions", deliveryDao.getAllRegions());
        return formData;
    }
    @Override
    public void updateVehicle(VehicleDto vehicle) {
        deliveryDao.updateVehicle(vehicle);
    }
    @Override
    public void deleteVehicle(int vehicleId) {
        if (deliveryDao.getDispatchCountForVehicle(vehicleId) > 0) {
            throw new DeletionException("해당 차량으로 진행된 배차 내역이 있어 삭제할 수 없습니다.");
        }
        deliveryDao.deleteVehicle(vehicleId);
    }
}
