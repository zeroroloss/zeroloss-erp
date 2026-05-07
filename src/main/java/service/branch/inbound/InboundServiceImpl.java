package service.branch.inbound;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.branch.inbound.InboundDAOImpl;
import dao.branch.inbound.InboundDao;
import dao.branch.inbound.InboundNotifiDao;
import dao.branch.inbound.InboundNotifiDaoImpl;
import dao.hq.delivery.DispatchDao;
import dao.hq.delivery.DispatchDaoImpl;
import dto.branch.inbound.InboundProcessingItemDTO;
import dto.hq.place_order.PlaceOrderProcessingDTO;
import dto.NotificationDTO;
import dto.NotificationReceiverDTO;
import dto.branch.inbound.InboundProcessingDTO;
import util.MyBatisSqlSessionFactory;

public class InboundServiceImpl implements InboundService {
	
	private final InboundDao dao = new InboundDAOImpl();
	private final InboundNotifiDao notifiDao = new InboundNotifiDaoImpl();
	private final DispatchDao dispatchDao = new DispatchDaoImpl();

	@Override
	public List<InboundProcessingDTO> findInboundsToProcess(int branchCode) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return dao.findInboundList(sqlSession, branchCode);
		} catch(Exception e) {
			throw new RuntimeException(e);
		}
	}

	@Override
	public boolean confirmInbound(int branchCode, String poNo, List<InboundProcessingItemDTO> items) {
		// 검증
		if (poNo == null || poNo.isBlank()) {
			throw new IllegalArgumentException("발주 번호가 필요합니다.");
		}
		if (items == null || items.isEmpty()) {
			throw new IllegalArgumentException("입고 품목이 비어있습니다.");
		}

		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
		
		try {
			Map<String, Object> outboundHeader = dao.findOutboundHeaderForConfirm(sqlSession, poNo, branchCode);
			if (outboundHeader == null || outboundHeader.get("hqOutboundNo") == null) {
				throw new IllegalStateException("입고 확정 가능한 출고 건이 없습니다.");
			}

			int hqOutboundNo = ((Number) outboundHeader.get("hqOutboundNo")).intValue();

			Map<String, Object> generatedPK = new HashMap<>();

			// 지점 재고 - 입고 내역 INSERT
			int insertedInbound = dao.insertBranchStockInbound(sqlSession, hqOutboundNo, branchCode, generatedPK);
			if (insertedInbound <= 0 || generatedPK.get("inboundId") == null) {
				throw new RuntimeException("입고 헤더 생성에 실패했습니다.");
			}

			int inboundId = ((Number) generatedPK.get("inboundId")).intValue();
			int confirmedDetailCount = 0;

			// 입고할 품목들 개별 처리
			for (InboundProcessingItemDTO item : items) {
				if (item == null || item.getHqOutboundDetailId() == null || item.getReceivedQty() == null) {
					continue;
				}

				BigDecimal receivedQty = item.getReceivedQty();
				if (receivedQty.compareTo(BigDecimal.ZERO) <= 0) {
					continue;
				}

				// 입고할 재고의 - 출고 상세 SELECT
				Map<String, Object> outboundDetailRow = dao.findOutboundDetailForConfirm(sqlSession, item.getHqOutboundDetailId(), hqOutboundNo, branchCode);
				if (outboundDetailRow == null) {
					throw new IllegalStateException("유효하지 않은 출고 상세입니다: " + item.getHqOutboundDetailId());
				}

				Object outboundQtyObj = outboundDetailRow.get("outboundQty");
				BigDecimal outboundQty = outboundQtyObj instanceof BigDecimal
					? (BigDecimal) outboundQtyObj
					: new BigDecimal(String.valueOf(outboundQtyObj));
				if (receivedQty.compareTo(outboundQty) > 0) {
					throw new IllegalArgumentException("입고 수량이 출고 수량보다 큽니다.");
				}
				
				String stockNo = (String) outboundDetailRow.get("stockNo");
				if (stockNo == null) {
				    throw new IllegalStateException("stock_no 없음");
				}
				
				String branchStockCode = "B-" + stockNo + "-" + System.nanoTime();

				// 지점 재고 INSERT
				int insertedStock = dao.insertBranchStock(sqlSession, branchStockCode, branchCode, 
											(String) outboundDetailRow.get("materialCode"), (String)outboundDetailRow.get("expiryDate"), receivedQty);
				if (insertedStock <= 0) {
				    throw new RuntimeException("지점 재고 생성 실패");
				}

				// 입고 상세 INSERT
				int insertedDetail = dao.insertBranchStockInboundDetail(sqlSession, inboundId, item.getHqOutboundDetailId(), receivedQty, branchStockCode);
				if (insertedDetail <= 0) {
					throw new RuntimeException("입고 상세 생성에 실패했습니다.");
				}

				// 지점 재고 변동 INSERT
				int insertedHistory = dao.insertBranchStockInboundHistory(sqlSession, branchStockCode, receivedQty);
				if (insertedHistory <= 0) {
					throw new RuntimeException("재고 변동 이력 생성에 실패했습니다.");
				}

				confirmedDetailCount++;
			}

			if (confirmedDetailCount <= 0) {
				throw new IllegalArgumentException("입고 확정할 수량이 없습니다.");
			}

			// 발주를 'COMPLETED'로 UPDATE
			int updated = dao.updatePlaceOrderStatusCompleted(sqlSession, poNo, branchCode);
			if (updated <= 0) {
				throw new RuntimeException("발주 상태 변경에 실패했습니다.");
			}
			
			// 배차된 기사, 차량 해제
			releaseDispatchResources(sqlSession, poNo);
			
			// 알림 처리
			sendInboundNotification(sqlSession, branchCode, poNo);


			sqlSession.commit();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			sqlSession.rollback();
			throw new RuntimeException(e);
		} finally {
			sqlSession.close();
		}
	}
	
	private void releaseDispatchResources(SqlSession sqlSession, String poNo) {

	    Map<String, Object> dispatchInfo = dispatchDao.selectDispatchByPoNo(sqlSession, poNo);

	    if (dispatchInfo == null) {
	    	throw new RuntimeException("배차 정보가 없는 발주입니다.");
	    }

	    Integer vehicleId = (Integer) dispatchInfo.get("vehicleId");
	    Integer driverId = (Integer) dispatchInfo.get("driverId");

	    // 차량 복구
	    if (vehicleId == null) {
	    	throw new RuntimeException("배차된 차량이 없는 발주입니다.");
	    }
	    dispatchDao.updateVehicleStatus(vehicleId, "AVAILABLE");

	    // 기사 복구
	    if (driverId  == null) {
	    	throw new RuntimeException("배차된 차량이 없는 발주입니다.");
	    }
	    dispatchDao.updateDriverStatus(driverId, 1);
	}

	private void sendInboundNotification(SqlSession sqlSession, int branchCode, String poNo) {

		PlaceOrderProcessingDTO poHeader = notifiDao.selectOrderHeaderByPoNo(sqlSession, poNo);
		
		NotificationDTO dto = new NotificationDTO();
		dto.setCategory("ORDER");
		dto.setTitle("입고 완료");
		dto.setMessage("[" + poHeader.getBranchName() + "] (지점 코드: " + branchCode + ") - 발주번호 "
			    + poNo + " - 입고가 완료되었습니다.");
		dto.setTargetType("ORDER");
		dto.setTargetId(poHeader.getPoId());

		int inserted = notifiDao.insertNotification(sqlSession, dto);
		if (inserted <= 0) {
			throw new RuntimeException("알림 생성 실패");
		}
		// generated Id
		int notificationId = dto.getNotificationId();

		List<Integer> accountIds =
				notifiDao.findHqAccountIds(sqlSession);

		for (Integer accountId : accountIds) {
			NotificationReceiverDTO receiver = new NotificationReceiverDTO();
			receiver.setNotificationId(notificationId);
			receiver.setAccountId(accountId);

			notifiDao.insertReceiver(sqlSession, receiver);
		}
	}

}
