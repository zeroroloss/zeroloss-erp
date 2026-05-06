package dao.hq.delivery;

import dto.hq.delivery.DispatchOrderDto;
import dto.hq.delivery.DriverDto;
import dto.hq.delivery.PlaceOrderDetailDto;
import dto.hq.delivery.RegionDto;
import dto.hq.delivery.VehicleDto;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;

import java.util.List;
import java.util.Map;

public interface DispatchDao {
    List<DispatchOrderDto> getPendingOrders();
    List<PlaceOrderDetailDto> getOrderDetailsByPoNo(@Param("poNo") String poNo);
    List<DriverDto> getAvailableDrivers(@Param("regionCode") String regionCode);
    List<VehicleDto> getAvailableVehicles();
    List<dto.hq.delivery.DispatchDeliveryDto> getAllDispatches();
    void createDispatch(int driverId, int vehicleId, String poNo);
    void updatePlaceOrderStatus(@Param("poNo") String poNo, @Param("status") String status);
    void updateVehicleStatus(@Param("vehicleId") int vehicleId, @Param("status") String status);
    void updateDriverStatus(@Param("vehicleId") int driverId, @Param("isActive") int isActive);
    List<RegionDto> getAllRegions();
	Map<String, Object> selectDispatchByPoNo(SqlSession sqlSession, String poNo);
    
}
