package service.branch.inbound;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.branch.inbound.InboundDAOImpl;
import dao.branch.inbound.InboundDao;
import dto.branch.inbound.InboundProcessingItemDTO;
import dto.branch.inbound.InboundProcessingDTO;
import util.MyBatisSqlSessionFactory;

public class InboundServiceImpl implements InboundService {
	
	private final InboundDao dao = new InboundDAOImpl();

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

			sqlSession.commit();
			return true;
		} catch (Exception e) {
			sqlSession.rollback();
			throw new RuntimeException(e);
		} finally {
			sqlSession.close();
		}
	}

}
