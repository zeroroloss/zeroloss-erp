package dao.hq.place_order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.hq.place_order.OrderQuantityLimitDTO;

public class OrderQuantityLimitDaoImpl implements OrderQuantityLimitDao {

	@Override
	public List<OrderQuantityLimitDTO> selectItemLimits(SqlSession sqlSession, Map<String, Object> param) throws Exception {
		return sqlSession.selectList("mapper.hq.place_order.OrderQuantityLimitMapper.selectLimits", param);

	}

	@Override
	public int updateItemLimit(SqlSession sqlSession, Map<String, Object> param) throws Exception {
		int updated = sqlSession.insert("mapper.hq.place_order.OrderQuantityLimitMapper.updateItemLimit", param);
		return updated;
	}
}