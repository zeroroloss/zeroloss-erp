package service.hq.delivery;

import dao.hq.delivery.DispatchDao;
import dao.hq.delivery.DispatchDaoImpl;
import dao.hq.delivery.DispatchNotifiDao;
import dao.hq.delivery.DispatchNotifiDaoImpl;
import dto.NotificationDTO;
import dto.NotificationReceiverDTO;
import dto.branch.place_order.PlaceOrderDTO;
import dto.hq.delivery.DispatchCreationDto;
import dto.hq.delivery.PlaceOrderDetailDto;
import dto.hq.place_order.PlaceOrderProcessingDTO;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DispatchServiceImpl implements DispatchService {
    private final SqlSessionFactory sqlSessionFactory = MyBatisSqlSessionFactory.getSqlSessionFactory();
    private final DispatchDao dispatchDao = new DispatchDaoImpl();
    private final DispatchNotifiDao dispatchNotifiDao = new DispatchNotifiDaoImpl();

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
    public List<dto.hq.delivery.DispatchDeliveryDto> getAllDispatches() {
        return dispatchDao.getAllDispatches();
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
                orderParams.put("status", "DELIVERED");
                session.update("mapper.dispatchMapper.updatePlaceOrderStatus", orderParams);

                Map<String, Object> vehicleParams = new HashMap<>();
                vehicleParams.put("vehicleId", dto.getVehicleId());
                vehicleParams.put("status", "IN_TRANSIT");
                session.update("mapper.dispatchMapper.updateVehicleStatus", vehicleParams);
                
                // 알림 처리 (본사 -> 직영점)
                sendDispatchNotification(session, dto.getPoNo());

                session.commit();
            } catch (Exception e) {
                session.rollback();
                e.printStackTrace();
                throw new RuntimeException("배차 생성 중 오류가 발생했습니다.", e);
            }
        }
    }
    
    // 알림 처리 메서드
    private void sendDispatchNotification(SqlSession sqlSession, String poNo) {

    	//  1. 발주 정보 조회
    	PlaceOrderProcessingDTO poHeader = dispatchNotifiDao.findPlaceOrderHeaderByPoNo(sqlSession, poNo);
    	if (poHeader == null) {
            throw new RuntimeException("발주 정보를 찾을 수 없습니다: " + poNo);
        }
        // 2. notification insert
        NotificationDTO notifiDTO = new NotificationDTO();
        notifiDTO.setCategory("ORDER");
        notifiDTO.setTitle("배송 완료");
        notifiDTO.setMessage(poHeader.getBranchName() + "지점 - 발주번호 " + poNo + ") 배차 완료 후 배송되었습니다.");
        notifiDTO.setTargetType("ORDER");
        notifiDTO.setTargetId(poHeader.getPoId());

        int inserted = dispatchNotifiDao.insertNotification(sqlSession, notifiDTO);
        if (inserted <= 0) {
            throw new RuntimeException("알림 생성 실패");
        }

        // generatedId
        int notificationId = notifiDTO.getNotificationId();

        // 3. 지점 계정 조회
        List<Integer> accountIds = dispatchNotifiDao.findAccountIdsByPoNo(sqlSession, poNo);

        // 4. receiver insert
        for (Integer accountId : accountIds) {
            NotificationReceiverDTO receiver = new NotificationReceiverDTO();
            receiver.setNotificationId(notificationId);
            receiver.setAccountId(accountId);

            dispatchNotifiDao.insertNotifiReceiver(sqlSession, receiver);
        }
    }
}
