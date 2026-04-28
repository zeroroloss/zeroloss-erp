package service.hq.place_order;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.hq.place_order.OrderQuantityLimitDao;
import dao.hq.place_order.OrderQuantityLimitDaoImpl;
import dto.hq.place_order.OrderQuantityLimitDTO;
import util.MyBatisSqlSessionFactory;

public class OrderQuantityLimitServiceImpl implements OrderQuantityLimitService {

	private final OrderQuantityLimitDao dao = new OrderQuantityLimitDaoImpl();
	
	@Override
	public List<OrderQuantityLimitDTO> selectLimits(String categoryName, String itemName) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			Map<String, Object> param = new HashMap<>();
			param.put("categoryName", categoryName);
			param.put("itemName", itemName);
			return dao.selectItemLimits(sqlSession, param);
		}

	}

	@Override
	public int updateLimit(String materialCode, BigDecimal minQty, BigDecimal maxQty) throws Exception {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {

            Map<String, Object> param = new HashMap<>();
            param.put("materialCode", materialCode);
            param.put("minQty", minQty);
            param.put("maxQty", maxQty);

            // DAO 호출로 변경
            int updated = dao.updateItemLimit(sqlSession, param);

            if (updated > 0) {
                sqlSession.commit();
            }

            return updated;
        }

	}
}