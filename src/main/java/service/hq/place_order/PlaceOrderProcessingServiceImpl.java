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

    @Override
    public boolean approveOrder(String poNo, List<PlaceOrderProcessingDetailDTO> details) {
        SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
        try {
            PlaceOrderProcessingDTO header = dao.selectOrderHeaderByPoNo(sqlSession, poNo);
            if (header == null) {
                return false;
            }

            // 발주 상세
            List<PlaceOrderProcessingDetailDTO> fullDetails = dao.selectOrderDetailsByPoNo(sqlSession, poNo);
            if (fullDetails == null) {
                fullDetails = new java.util.ArrayList<>();
            }

            if (details != null) {
                for (PlaceOrderProcessingDetailDTO detail : details) {
                    if (detail == null || detail.getPoDetailId() == null) {
                        continue;
                    }
                    int approvedQty = detail.getApprovedQty() == null ? 0 : Math.max(0, detail.getApprovedQty());

                    Map<String, Object> param = new HashMap<>();
                    param.put("poDetailId", detail.getPoDetailId());
                    param.put("approvedQty", approvedQty);
                    dao.updateApprovedQtyByDetailId(sqlSession, param);

                    //
                    PlaceOrderProcessingDetailDTO fullDetail = fullDetails.stream()
                            .filter(d -> d != null && d.getPoDetailId().equals(detail.getPoDetailId()))
                            .findFirst()
                            .orElse(null);

                    if (fullDetail != null && approvedQty > 0) {
                        // 본사 물류창고 재고 감소
                        Map<String, Object> deductParam = new HashMap<>();
                        deductParam.put("materialCode", fullDetail.getMaterialCode());
                        deductParam.put("deductQty", approvedQty);
                        int deducted = dao.deductWarehouseStock(sqlSession, deductParam);
                        
                        if (deducted <= 0) {
                            sqlSession.rollback();
                            throw new RuntimeException("본사 물류창고 재고가 부족합니다. 품목: " + fullDetail.getMaterialName() + ", 필요량: " + approvedQty);
                        }
                    }
                }
            }

            int updated = dao.updateOrderStatusApprove(sqlSession, poNo);
            if (updated <= 0) {
                sqlSession.rollback();
                return false;
            }
            
            // 1. 출고 헤더 생성
            Map<String, Object> outboundParam = new HashMap<>();
            outboundParam.put("poNo", poNo);
            outboundParam.put("branchCode", header.getBranchCode());

            dao.insertOutbound(sqlSession, outboundParam);

            // PK 받아오기
            Number key = (Number) outboundParam.get("hqOutboundNo");
            Integer hqOutboundNo = key.intValue();
            
            // 2. 출고 상세 생성
            for (PlaceOrderProcessingDetailDTO detail : fullDetails) {

                int approvedQty = detail.getApprovedQty() == null ? 0 : detail.getApprovedQty();
                if (approvedQty <= 0) continue;

                Map<String, Object> param = new HashMap<>();
                param.put("hqOutboundNo", hqOutboundNo);

                // materialCode → stockNo 변환
                String stockNo = dao.selectStockNoByMaterialCode(sqlSession, detail.getMaterialCode());
                param.put("stockNo", stockNo);

                param.put("qty", approvedQty);

                dao.insertOutboundDetail(sqlSession, param);
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
