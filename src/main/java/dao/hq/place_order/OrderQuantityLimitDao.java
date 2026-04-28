package dao.hq.place_order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.hq.place_order.OrderQuantityLimitDTO;

public interface OrderQuantityLimitDao {
	List<OrderQuantityLimitDTO> selectItemLimits(SqlSession sqlSession, Map<String, Object> param) throws Exception;
	int updateItemLimit(SqlSession sqlSession, Map<String, Object> param) throws Exception;
}