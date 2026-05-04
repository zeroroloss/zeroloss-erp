package service.hq.place_order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.hq.place_order.PlaceOrderProcessingDao;
import dao.hq.place_order.PlaceOrderProcessingDaoImpl;
import dto.hq.place_order.PlaceOrderProcessingDTO;
import dto.hq.place_order.PlaceOrderProcessingDetailDTO;
import util.MyBatisSqlSessionFactory;

public class PlaceOrderProcessingServiceImpl implements PlaceOrderProcessingService {

    private final PlaceOrderProcessingDao dao = new PlaceOrderProcessingDaoImpl();

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
      승인수량 저장 
      -> 출고 헤더 생성 
      -> 재고 FIFO 조회 
      -> stock_no별로 쪼개서
      -> 차감 & outbound_detail 여러 줄 insert
     */    
    @Override
    public boolean approveOrder(String poNo, List<PlaceOrderProcessingDetailDTO> details) {
    	
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
        
        try {
        	// 1. 발주 헤더 조회
            PlaceOrderProcessingDTO header = dao.selectOrderHeaderByPoNo(sqlSession, poNo);
            if (header == null) {
                return false;
            }

            // 2. 전체 발주 상세 조회
            List<PlaceOrderProcessingDetailDTO> fullDetails = dao.selectOrderDetailsByPoNo(sqlSession, poNo);
            if (fullDetails == null) {
                fullDetails = new java.util.ArrayList<>();
            }

            // 3. 승인 수량 업데이트
            if (details != null) {
                for (PlaceOrderProcessingDetailDTO detail : details) {
                    if (detail == null || detail.getPoDetailId() == null) 
                    	continue;

                    int approvedQty = detail.getApprovedQty() == null ? 0 : detail.getApprovedQty();
                    
                    Map<String, Object> param = new HashMap<>();
                    param.put("poDetailId", detail.getPoDetailId());
                    param.put("approvedQty", approvedQty);

                    dao.updateApprovedQtyByDetailId(sqlSession, param);
                }
            }
            
            // 4. 출고 헤더 생성
            Map<String, Object> outboundParam = new HashMap<>();
            outboundParam.put("poNo", poNo);
            outboundParam.put("branchCode", header.getBranchCode());
            
            dao.insertOutbound(sqlSession, outboundParam);
            // DB 자동 생성 ID 가져오기
            Number generatedId = (Number) outboundParam.get("hqOutboundNo");
            Integer hqOutboundNo = generatedId.intValue();
            
            // 5. 재고 차감(FIFO) & 출고 상세 생성
            for (PlaceOrderProcessingDetailDTO detail : fullDetails) {
            	
            	int approvedQty = detail.getApprovedQty() == null ? 0 : detail.getApprovedQty();
            	if (approvedQty <= 0) continue;
            	
            	// remainingQty : 아직 출고해야 할 수량 (FIFO 처리용)
            	int remainingQty = approvedQty;
            	
            	// 5-1. FIFO 재고 조회 (유통기한, 물류창고 입고 시점 정렬)
            	//      재료코드에 해당하는 모든 재고들 가져오기
            	List<Map<String, Object>> stocks =
            			dao.selectStockLotsByMaterialCode(sqlSession, detail.getMaterialCode());
            	
            	if (stocks == null || stocks.isEmpty()) {
            		sqlSession.rollback();
            		throw new RuntimeException("재고 없음 : " + detail.getMaterialName());
            	}
            	
            	// 5-2. 재료코드에 해당하는 모든 재고들 대해 재고 차감
            	for (Map<String, Object> stock : stocks) {
            		
            		if (remainingQty <= 0) break;
            		
            		String stockNo = (String) stock.get("stock_no");
            		int stockQty = ((Number)stock.get("qty")).intValue();
            		if (stockQty <= 0) continue;
            		
            		// 출고 차감 수량
            		int deductQty = Math.min(stockQty, remainingQty);
            		
            		// 5-2-1. 본사 재고 차감
            		Map<String, Object> deductParam = new HashMap<>();
            		deductParam.put("stockNo", stockNo);
            		deductParam.put("deductQty", deductQty);
            		
            		int deducted = dao.deductWarehouseStockByStockNo(sqlSession, deductParam);
            		if (deducted <= 0) {
            			sqlSession.rollback();
            			throw new RuntimeException("재고 차감 실패");
            		}
            		
            		// 5-2-2. 출고 상세 생성
            		Map<String, Object> outboundDetailParam = new HashMap<>();
            		outboundDetailParam.put("hqOutboundNo", hqOutboundNo);
            		outboundDetailParam.put("stockNo", stockNo);
            		outboundDetailParam.put("qty", deductQty);
            		
            		dao.insertOutboundDetail(sqlSession, outboundDetailParam);
            		
            		// 재고 0이면 상태를 변경
            		dao.updateStockStatusIfEmpty(sqlSession, stockNo);
            		
            		remainingQty -= deductQty;
            	}
            	
            	// 재고 부족 체크 (미승인 수량 0보다 큼)
            	if (remainingQty > 0) {
            		sqlSession.rollback();
            		throw new RuntimeException("재고 부족" + detail.getMaterialName() +": " + detail.getMaterialName()
            								+ "지점 필요=" + approvedQty +", 본사 재고 부족=" + remainingQty);
            	}
            }
            
            // 6. 상태 변경
            int updated = dao.updateOrderStatusApprove(sqlSession, poNo);
            if (updated <= 0) {
            	sqlSession.rollback();
            	return false;
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

    @Override
    public boolean rejectOrder(String poNo, String rejectReason) {
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
        try {
            Map<String, Object> param = new HashMap<>();
            param.put("poNo", poNo);
            param.put("rejectReason", rejectReason);

            int updated = dao.updateOrderStatusReject(sqlSession, param);
            if (updated <= 0) {
                sqlSession.rollback();
                return false;
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
