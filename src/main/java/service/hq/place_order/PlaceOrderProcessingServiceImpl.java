package service.hq.place_order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.branch.place_order.PlaceOrderNotificationDao;
import dao.branch.place_order.PlaceOrderNotificationDaoImpl;
import dao.hq.place_order.PlaceOrderProcessingDao;
import dao.hq.place_order.PlaceOrderProcessingDaoImpl;
import dto.NotificationDTO;
import dto.NotificationReceiverDTO;
import dto.hq.place_order.PlaceOrderProcessingDTO;
import dto.hq.place_order.PlaceOrderProcessingDetailDTO;
import util.MyBatisSqlSessionFactory;

public class PlaceOrderProcessingServiceImpl implements PlaceOrderProcessingService {

	private final PlaceOrderProcessingDao dao = new PlaceOrderProcessingDaoImpl();
	private final PlaceOrderNotificationDao notifiDao = new PlaceOrderNotificationDaoImpl();

	@Override
	public List<PlaceOrderProcessingDTO> getPendingOrders() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return dao.selectPendingOrders(sqlSession);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	@Override
	public PlaceOrderProcessingDTO getOrderDetail(String poNo) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			PlaceOrderProcessingDTO header = dao.selectOrderHeaderByPoNo(sqlSession, poNo);
			if (header == null) {
				return null;
			}

			List<PlaceOrderProcessingDetailDTO> details = dao.selectOrderDetailsByPoNo(sqlSession, poNo);
			header.setDetails(details);
			return header;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	/*
	 * 승인수량 저장 -> 출고 헤더 생성 -> 재고 FIFO 조회 -> stock_no별로 쪼개서 -> 차감 & outbound_detail
	 * 여러 줄 insert
	 */
	@Override
	public boolean approveOrder(String poNo, List<PlaceOrderProcessingDetailDTO> details) {

		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);

		try {
			System.out.println("\n================= [APPROVE ORDER START] =================");
			System.out.println("[PO] " + poNo);

			// 1. 발주 헤더 조회
			PlaceOrderProcessingDTO poHeader = dao.selectOrderHeaderByPoNo(sqlSession, poNo);
			if (poHeader == null) {
				System.out.println("[ERROR] 발주 헤더 없음");
				return false;
			}

			System.out.println("[HEADER] branchCode=" + poHeader.getBranchCode());

			// 2. 전체 상세 조회
			List<PlaceOrderProcessingDetailDTO> fullDetails = dao.selectOrderDetailsByPoNo(sqlSession, poNo);
			if (fullDetails == null)
				fullDetails = new java.util.ArrayList<>();

			System.out.println("[DETAIL COUNT] " + fullDetails.size());

			// 3. 승인 수량 업데이트
			System.out.println("\n--- [STEP 3] 승인 수량 업데이트 ---");
			if (details != null) {
				for (PlaceOrderProcessingDetailDTO d : details) {

					if (d == null || d.getPoDetailId() == null)
						continue;

					int approvedQty = d.getApprovedQty() == null ? 0 : d.getApprovedQty();

					Map<String, Object> param = new HashMap<>();
					param.put("poDetailId", d.getPoDetailId());
					param.put("approvedQty", approvedQty);

					dao.updateApprovedQtyByDetailId(sqlSession, param);

					System.out.println("[UPDATE] detailId=" + d.getPoDetailId() + " approvedQty=" + approvedQty);
				}
			}

			// 재조회 (중요)
			fullDetails = dao.selectOrderDetailsByPoNo(sqlSession, poNo);

			// 4. 출고 헤더 생성
			System.out.println("\n--- [STEP 4] 출고 헤더 생성 ---");

			Map<String, Object> outboundParam = new HashMap<>();
			outboundParam.put("poNo", poNo);
			outboundParam.put("branchCode", poHeader.getBranchCode());

			int inserted = dao.insertOutbound(sqlSession, outboundParam);

			if (inserted <= 0) {
				throw new RuntimeException("출고 헤더 생성 실패");
			}

			Integer hqOutboundNo = ((Number) outboundParam.get("hqOutboundNo")).intValue();

			System.out.println("[OUTBOUND CREATED] hqOutboundNo=" + hqOutboundNo);

			// 5. FIFO 재고 차감
			System.out.println("\n================= [FIFO START] =================");

			for (PlaceOrderProcessingDetailDTO detail : fullDetails) {

				int approvedQty = detail.getApprovedQty() == null ? 0 : detail.getApprovedQty();
				if (approvedQty <= 0)
					continue;

				System.out.println("\n[ITEM START]");
				System.out.println("material=" + detail.getMaterialName() + " (" + detail.getMaterialCode() + ")"
						+ " approvedQty=" + approvedQty);

				int remainingQty = approvedQty;

				List<Map<String, Object>> stocks = dao.selectStockLotsByMaterialCode(sqlSession,
						detail.getMaterialCode());

				if (stocks == null || stocks.isEmpty()) {
					throw new RuntimeException("재고 없음: " + detail.getMaterialName());
				}

				for (Map<String, Object> stock : stocks) {

					if (remainingQty <= 0)
						break;

					String stockNo = (String) stock.get("stock_no");
					int beforeQty = ((Number) stock.get("qty")).intValue();

					if (beforeQty <= 0)
						continue;

					int deductQty = Math.min(beforeQty, remainingQty);

					System.out.println(
							"  [STOCK BEFORE] stockNo=" + stockNo + " qty=" + beforeQty + " -> deduct=" + deductQty);

					// 차감
					Map<String, Object> deductParam = new HashMap<>();
					deductParam.put("stockNo", stockNo);
					deductParam.put("deductQty", deductQty);

					int deducted = dao.deductWarehouseStockByStockNo(sqlSession, deductParam);

					if (deducted <= 0) {
						throw new RuntimeException("재고 차감 실패: " + stockNo);
					}

					// 차감 후 조회
					Map<String, Object> stockAfter = dao.selectStockByStockNo(sqlSession, stockNo);

					if (stockAfter == null) {
						throw new RuntimeException("재고 조회 실패: " + stockNo);
					}

					int afterQty = ((Number) stockAfter.get("qty")).intValue();

					System.out.println("  [STOCK AFTER ] stockNo=" + stockNo + " afterQty=" + afterQty);

					// 재고 이력
					Map<String, Object> historyParam = new HashMap<>();
					historyParam.put("stockNo", stockNo);
					historyParam.put("status", "OUTBOUND");
					historyParam.put("changeAmount", -deductQty);
					historyParam.put("afterQty", afterQty);

					dao.insertStockHistory(sqlSession, historyParam);

					System.out.println("  [HISTORY] change=" + (-deductQty) + " after=" + afterQty);

					// 출고 상세
					Map<String, Object> outboundDetailParam = new HashMap<>();
					outboundDetailParam.put("hqOutboundNo", hqOutboundNo);
					outboundDetailParam.put("stockNo", stockNo);
					outboundDetailParam.put("qty", deductQty);

					int detailInserted = dao.insertOutboundDetail(sqlSession, outboundDetailParam);

					if (detailInserted <= 0) {
						throw new RuntimeException("출고 상세 생성 실패: " + stockNo);
					}

					System.out.println("  [OUTBOUND DETAIL] stockNo=" + stockNo + " qty=" + deductQty);

					// 재고 0 처리
					int updatedEmpty = dao.updateStockStatusIfEmpty(sqlSession, stockNo);
					if (updatedEmpty > 0) {
						System.out.println("  [STOCK STATUS] " + stockNo + " → OUT_OF_STOCK");
					}

					remainingQty -= deductQty;
				}

				if (remainingQty > 0) {
					throw new RuntimeException("재고 부족: " + detail.getMaterialName() + " 부족=" + remainingQty);
				}

				System.out.println("[ITEM DONE]");
			}

			// 6. 상태 변경
			System.out.println("\n--- [STEP 6] 상태 변경 ---");

			int updated = dao.updateOrderStatusApprove(sqlSession, poNo);

			if (updated <= 0) {
				throw new RuntimeException("상태 변경 실패");
			}

			System.out.println("[ORDER STATUS] PENDING → APPROVED");

			// 7. 알림 보내기
			sendOrderNotification(
				    sqlSession,
				    poHeader,
				    "발주 승인 완료",
				    "발주번호 " + poNo + " 가 승인되었습니다. (지점" + poHeader.getBranchCode() +  ") " +poHeader.getBranchName()
				);

			sqlSession.commit();

			System.out.println("================= [APPROVE SUCCESS] =================\n");
			return true;

		} catch (Exception e) {

			System.out.println("\n!!!!!!!!!! [APPROVE FAIL] !!!!!!!!!!");
			System.out.println("[PO] " + poNo);
			System.out.println("[ERROR] " + e.getMessage());
			e.printStackTrace();

			sqlSession.rollback();
			throw new RuntimeException(e);

		} finally {
			sqlSession.close();
		}
	}

	@Override
	public boolean rejectOrder(String poNo, String rejectReason) {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
		try {
			// 반려 처리 ======================
			Map<String, Object> param = new HashMap<>();
			param.put("poNo", poNo);
			param.put("rejectReason", rejectReason);

			int updated = dao.updateOrderStatusReject(sqlSession, param);
			if (updated <= 0) {
				sqlSession.rollback();
				return false;
			}
			// ==============================

			// 알림 보내기 =====================
			// poId 가져오기 위해 poNo 발주서 번호로 발주 정보 가져오기
			PlaceOrderProcessingDTO poHeader = dao.selectOrderHeaderByPoNo(sqlSession, poNo);
			sendOrderNotification(
				    sqlSession,
				    poHeader,
				    "발주 요청 반려됨",
				    "발주번호 " + poNo + " 가 반려되었습니다. 사유: " + rejectReason
				);

			sqlSession.commit();
			return true;
		} catch (Exception e) {
			sqlSession.rollback();
			throw new RuntimeException(e);
		} finally {
			sqlSession.close();
		}
	}

	private void sendOrderNotification(SqlSession sqlSession, PlaceOrderProcessingDTO poHeader, String title,
			String message) {

		// 1. notification 생성
		NotificationDTO notifiDTO = new NotificationDTO();
		notifiDTO.setCategory("ORDER");
		notifiDTO.setTitle(title);
		notifiDTO.setMessage(message);
		notifiDTO.setTargetType("ORDER");
		notifiDTO.setTargetId(poHeader.getPoId());
		
		// generatedPK 받아옴
		int inserted = notifiDao.insertNotification(sqlSession, notifiDTO);
		if (inserted <= 0) {
			throw new RuntimeException("생성된 알림이 없습니다.");
		}
		int notificationId = notifiDTO.getNotificationId();

		// 2. 수신자 조회 (지점 계정들)
		List<Integer> accountIds = notifiDao.selectAccountIdsByBranchCode(sqlSession, poHeader.getBranchCode());
		if (accountIds == null || accountIds.isEmpty()) {
		    System.out.println("[WARN] 수신자 없음 branchCode=" + poHeader.getBranchCode());
		    return;
		}
		
		// 3. receiver insert
		for (Integer accountId : accountIds) {
			NotificationReceiverDTO receiver = new NotificationReceiverDTO();
			receiver.setNotificationId(notificationId);
			receiver.setAccountId(accountId);
			// receiver.setIsRead(0); -> DB생성 쿼리에서 default '0'

			notifiDao.insertNotifiReceiver(sqlSession, receiver);
		}
	}
}
