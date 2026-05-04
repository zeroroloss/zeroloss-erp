package dao.hq.place_order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.hq.place_order.PlaceOrderOverviewDTO;
import dto.hq.place_order.PlaceOrderOverviewDetailDTO;
import dto.hq.place_order.PlaceOrderOverviewMaterialDTO;
import util.MyBatisSqlSessionFactory;

public class PlaceOrderOverviewDaoImpl implements PlaceOrderOverviewDao {
	private static final String NAME_SPACE = "mapper.hq.place_order.overview.";
	
	@Override
	public List<String> findAllBranchNames(SqlSession sqlSession) {
		return sqlSession.selectList(NAME_SPACE + "selectAllBranchNames");
	}

	@Override
	public List<PlaceOrderOverviewDTO> findPlaceOrders(SqlSession sqlSession, Map<String, String> params) {
		return sqlSession.selectList(NAME_SPACE + "selectPlaceOrders", params);
	}

	@Override
	public PlaceOrderOverviewDetailDTO findDetailByPoId(SqlSession sqlSession, int poId) {
	    return sqlSession.selectOne(NAME_SPACE + "selectPlaceOrderDetail", poId);
	}

	@Override
	public List<PlaceOrderOverviewMaterialDTO> findDetailItemsByPoId(SqlSession sqlSession, int poId) {
	    return sqlSession.selectList(NAME_SPACE + "selectPlaceOrderItems", poId);
	}

	@Override
	public Integer selectPendingCnt() throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne(NAME_SPACE + "selectPendingCnt");
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

}
