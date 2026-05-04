package service.hq.place_order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.hq.place_order.PlaceOrderOverviewDao;
import dao.hq.place_order.PlaceOrderOverviewDaoImpl;
import dto.hq.place_order.PlaceOrderOverviewDTO;
import dto.hq.place_order.PlaceOrderOverviewDetailDTO;
import dto.hq.place_order.PlaceOrderOverviewMaterialDTO;
import util.MyBatisSqlSessionFactory;

public class PlaceOrderOverviewServiceImpl implements PlaceOrderOverviewService {
	
	private final PlaceOrderOverviewDao dao = new PlaceOrderOverviewDaoImpl();

	@Override
	public List<String> findAllBranchNames() {
	    try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
	    	return dao.findAllBranchNames(sqlSession);
	    } 
	}

	@Override
	public List<PlaceOrderOverviewDTO> findPlaceOrders(Map<String, String> params) {
	    try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
	    	return dao.findPlaceOrders(sqlSession, params);
	    }
	}

	@Override
	public PlaceOrderOverviewDetailDTO findDetailByPoId(int poId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
		    PlaceOrderOverviewDetailDTO detail =
		    		dao.findDetailByPoId(sqlSession, poId);
		    if (detail == null) {
		        throw new RuntimeException("발주 없음: " + poId);
		    }
		    
		    List<PlaceOrderOverviewMaterialDTO> items =
		    		dao.findDetailItemsByPoId(sqlSession, poId);

		    detail.setItems(items);

		    return detail;
	    }
	}

	@Override
	public Integer selectPendingCnt() throws Exception {
		Integer cnt = dao.selectPendingCnt();
		return cnt;
	}
}
