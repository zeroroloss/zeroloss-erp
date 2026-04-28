package dao.branch.place_order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.branch.place_order.PlaceOrderDetailDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.branch.place_order.PlaceOrderRequestDTO;
import dto.branch.place_order.PlaceOrderRequestDetailDTO;
import util.MyBatisSqlSessionFactory;

public class PlaceOrderDAOImpl implements PlaceOrderDAO {

    private static final String MAPPER_NAMESPACE = "mapper.branch.placeOrderMapper.";
    private static final String SELECT_PLACE_ORDER_HISTORY = MAPPER_NAMESPACE + "selectPlaceOrderHistory";
    private static final String SELECT_PLACE_ORDER_DETAIL = MAPPER_NAMESPACE + "selectPlaceOrderDetail";
    private static final String SELECT_PLACE_ORDER_DETAILS = MAPPER_NAMESPACE + "selectPlaceOrderDetails";
    private static final String INSERT_PLACE_ORDER = MAPPER_NAMESPACE + "insertPlaceOrder";
    private static final String INSERT_PLACE_ORDER_DETAILS = MAPPER_NAMESPACE + "insertPlaceOrderDetails";
    private static final String UPDATE_PLACE_ORDER_STATUS = MAPPER_NAMESPACE + "updatePlaceOrderStatus";

    @Override
    public List<PlaceOrderHistoryDTO> selectPlaceOrderHistory(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return sqlSession.selectList(SELECT_PLACE_ORDER_HISTORY, params);
        }
    }

    @Override
    public PlaceOrderHistoryDTO selectPlaceOrderDetail(String poNo) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return sqlSession.selectOne(SELECT_PLACE_ORDER_DETAIL, poNo);
        }
    }

    @Override
    public List<PlaceOrderDetailDTO> selectPlaceOrderDetails(String poNo) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return sqlSession.selectList(SELECT_PLACE_ORDER_DETAILS, poNo);
        }
    }

    @Override
    public int insertPlaceOrder(PlaceOrderRequestDTO requestDTO) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            int result = sqlSession.insert(INSERT_PLACE_ORDER, requestDTO);
            sqlSession.commit();
            return result;
        }
    }

    @Override
    public int insertPlaceOrderDetails(Integer poId, List<PlaceOrderRequestDetailDTO> details) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("poId", poId);
            params.put("details", details);
            int result = sqlSession.insert(INSERT_PLACE_ORDER_DETAILS, params);
            sqlSession.commit();
            return result;
        }
    }

    @Override
    public int updatePlaceOrderStatus(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            int result = sqlSession.update(UPDATE_PLACE_ORDER_STATUS, params);
            sqlSession.commit();
            return result;
        }
    }
}