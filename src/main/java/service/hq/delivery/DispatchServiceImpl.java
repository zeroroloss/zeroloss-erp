package service.hq.delivery;

import dao.hq.delivery.DispatchDao;
import dao.hq.delivery.DispatchDaoImpl;
import dto.hq.delivery.DispatchCreationDto;
import dto.hq.delivery.PlaceOrderDetailDto;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DispatchServiceImpl implements DispatchService {
    private final SqlSessionFactory sqlSessionFactory = MyBatisSqlSessionFactory.getSqlSessionFactory();
    private final DispatchDao dispatchDao = new DispatchDaoImpl();

    @Override
    public Map<String, Object> getDispatchPageData() {
        Map<String, Object> pageData = new HashMap<>();
        pageData.put("pendingOrders", dispatchDao.getPendingOrders());
        pageData.put("regions", dispatchDao.getAllRegions());
        return pageData;
    }

    @Override
    public List<PlaceOrderDetailDto> getOrderDetails(String poNo) {
        return dispatchDao.getOrderDetailsByPoNo(poNo);
    }

    @Override
    public Map<String, Object> getDispatchModalData(String regionCode) {
        Map<String, Object> modalData = new HashMap<>();
        modalData.put("drivers", dispatchDao.getAvailableDrivers(regionCode));
        modalData.put("vehicles", dispatchDao.getAvailableVehicles());
        return modalData;
    }

    @Override
    public void createDispatch(DispatchCreationDto dto) {
        try (SqlSession session = sqlSessionFactory.openSession(false)) {
            try {
                Map<String, Object> dispatchParams = new HashMap<>();
                dispatchParams.put("poNo", dto.getPoNo());
                dispatchParams.put("driverId", dto.getDriverId());
                dispatchParams.put("vehicleId", dto.getVehicleId());
                session.insert("mapper.dispatchMapper.createDispatch", dispatchParams);

                Map<String, Object> orderParams = new HashMap<>();
                orderParams.put("poNo", dto.getPoNo());
                orderParams.put("status", "SHIPPING");
                session.update("mapper.dispatchMapper.updatePlaceOrderStatus", orderParams);

                Map<String, Object> vehicleParams = new HashMap<>();
                vehicleParams.put("vehicleId", dto.getVehicleId());
                vehicleParams.put("status", "IN_TRANSIT");
                session.update("mapper.dispatchMapper.updateVehicleStatus", vehicleParams);

                session.commit();
            } catch (Exception e) {
                session.rollback();
                e.printStackTrace();
                throw new RuntimeException("배차 생성 중 오류가 발생했습니다.", e);
            }
        }
    }
}
