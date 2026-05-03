package dao.hq.delivery;

import dto.hq.delivery.DriverCandidateDto;
import dto.hq.delivery.DriverDto;
import dto.hq.delivery.RegionDto;
import dto.hq.delivery.VehicleDto;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.MyBatisSqlSessionFactory;

import java.util.List;

public class DeliveryDaoImpl implements DeliveryDao {
    private final SqlSessionFactory sqlSessionFactory = MyBatisSqlSessionFactory.getSqlSessionFactory();

    // Driver methods
    @Override
    public List<DriverDto> getAllDrivers() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.deliveryMapper.getAllDrivers");
        }
    }
    @Override
    public DriverDto getDriverById(int driverId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectOne("mapper.deliveryMapper.getDriverById", driverId);
        }
    }
    @Override
    public List<DriverCandidateDto> getDriverCandidates() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.deliveryMapper.getDriverCandidates");
        }
    }
    @Override
    public void addDriver(DriverDto driver) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            session.insert("mapper.deliveryMapper.addDriver", driver);
        }
    }
    @Override
    public void updateDriver(DriverDto driver) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            session.update("mapper.deliveryMapper.updateDriver", driver);
        }
    }
    @Override
    public void deleteDriver(int driverId) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            session.delete("mapper.deliveryMapper.deleteDriver", driverId);
        }
    }
    @Override
    public int getDispatchedCount(int driverId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectOne("mapper.deliveryMapper.getDispatchedCount", driverId);
        }
    }

    // Vehicle methods
    @Override
    public List<VehicleDto> getAllVehicles() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.deliveryMapper.getAllVehicles");
        }
    }
    @Override
    public VehicleDto getVehicleById(int vehicleId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectOne("mapper.deliveryMapper.getVehicleById", vehicleId);
        }
    }
    @Override
    public void addVehicle(VehicleDto vehicle) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            session.insert("mapper.deliveryMapper.addVehicle", vehicle);
        }
    }
    @Override
    public void updateVehicle(VehicleDto vehicle) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            session.update("mapper.deliveryMapper.updateVehicle", vehicle);
        }
    }
    @Override
    public void deleteVehicle(int vehicleId) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            session.delete("mapper.deliveryMapper.deleteVehicle", vehicleId);
        }
    }
    @Override
    public int getDispatchCountForVehicle(int vehicleId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectOne("mapper.deliveryMapper.getDispatchCountForVehicle", vehicleId);
        }
    }

    // Common methods
    @Override
    public List<RegionDto> getAllRegions() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.deliveryMapper.getAllRegions");
        }
    }
}
