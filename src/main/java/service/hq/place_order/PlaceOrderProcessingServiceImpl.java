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
                }
            }

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
