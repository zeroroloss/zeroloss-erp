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

    @Override
    public List<PlaceOrderHistoryDTO> selectPlaceOrderHistory(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return sqlSession.selectList("mapper.branch.placeOrderMapper.selectPlaceOrderHistory", params);
        }
    }

    @Override
    public PlaceOrderHistoryDTO selectPlaceOrderDetail(String poNo) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return sqlSession.selectOne("mapper.branch.placeOrderMapper.selectPlaceOrderDetail", poNo);
        }
    }

    @Override
    public List<PlaceOrderDetailDTO> selectPlaceOrderDetails(String poNo) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return sqlSession.selectList("mapper.branch.placeOrderMapper.selectPlaceOrderDetails", poNo);
        }
    }

    @Override
    public int insertPlaceOrder(PlaceOrderRequestDTO requestDTO) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            int result = sqlSession.insert("mapper.branch.placeOrderMapper.insertPlaceOrder", requestDTO);
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
            int result = sqlSession.insert("mapper.branch.placeOrderMapper.insertPlaceOrderDetails", params);
            sqlSession.commit();
            return result;
        }
    }

    @Override
    public int updatePlaceOrderStatus(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            int result = sqlSession.update("mapper.branch.placeOrderMapper.updatePlaceOrderStatus", params);
            sqlSession.commit();
            return result;
        }
    }
}