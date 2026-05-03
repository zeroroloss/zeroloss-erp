package dao.hq.delivery;

import dto.hq.delivery.DispatchOrderDto;
import dto.hq.delivery.DriverDto;
import dto.hq.delivery.PlaceOrderDetailDto;
import dto.hq.delivery.RegionDto;
import dto.hq.delivery.VehicleDto;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DispatchDao {
    List<DispatchOrderDto> getPendingOrders();
    List<PlaceOrderDetailDto> getOrderDetailsByPoNo(@Param("poNo") String poNo);
    List<DriverDto> getAvailableDrivers(@Param("regionCode") String regionCode);
    List<VehicleDto> getAvailableVehicles();
    void createDispatch(int driverId, int vehicleId, String poNo);
    void updatePlaceOrderStatus(@Param("poNo") String poNo, @Param("status") String status);
    void updateVehicleStatus(@Param("vehicleId") int vehicleId, @Param("status") String status);
    List<RegionDto> getAllRegions();
}
