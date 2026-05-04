package dao.hq.delivery;

import dto.hq.delivery.DispatchOrderDto;
import dto.hq.delivery.DriverDto;
import dto.hq.delivery.PlaceOrderDetailDto;
import dto.hq.delivery.RegionDto;
import dto.hq.delivery.VehicleDto;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DispatchDaoImpl implements DispatchDao {
    private final SqlSessionFactory sqlSessionFactory = MyBatisSqlSessionFactory.getSqlSessionFactory();

    @Override
    public List<DispatchOrderDto> getPendingOrders() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.dispatchMapper.getPendingOrders");
        }
    }

    @Override
    public List<PlaceOrderDetailDto> getOrderDetailsByPoNo(String poNo) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.dispatchMapper.getOrderDetailsByPoNo", poNo);
        }
    }

    @Override
    public List<DriverDto> getAvailableDrivers(String regionCode) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.dispatchMapper.getAvailableDrivers", regionCode);
        }
    }

    @Override
    public List<VehicleDto> getAvailableVehicles() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.dispatchMapper.getAvailableVehicles");
        }
    }

    @Override
    public List<dto.hq.delivery.DispatchDeliveryDto> getAllDispatches() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.dispatchMapper.selectAllDispatches");
        }
    }

    @Override
    public void createDispatch(int driverId, int vehicleId, String poNo) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            Map<String, Object> params = new HashMap<>();
            params.put("driverId", driverId);
            params.put("vehicleId", vehicleId);
            params.put("poNo", poNo);
            session.insert("mapper.dispatchMapper.createDispatch", params);
        }
    }

    @Override
    public void updatePlaceOrderStatus(String poNo, String status) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            Map<String, Object> params = new HashMap<>();
            params.put("poNo", poNo);
            params.put("status", status);
            session.update("mapper.dispatchMapper.updatePlaceOrderStatus", params);
        }
    }

    @Override
    public void updateVehicleStatus(int vehicleId, String status) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            Map<String, Object> params = new HashMap<>();
            params.put("vehicleId", vehicleId);
            params.put("status", status);
            session.update("mapper.dispatchMapper.updateVehicleStatus", params);
        }
    }

    @Override
    public List<RegionDto> getAllRegions() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.dispatchMapper.getAllRegions");
        }
    }
}
