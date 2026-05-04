package dao.hq.place_order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.hq.place_order.PlaceOrderOverviewDTO;
import dto.hq.place_order.PlaceOrderOverviewDetailDTO;
import dto.hq.place_order.PlaceOrderOverviewMaterialDTO;

public interface PlaceOrderOverviewDao {

	List<String> findAllBranchNames(SqlSession sqlSession);

	// 조회하기
	List<PlaceOrderOverviewDTO> findPlaceOrders(SqlSession sqlSession, Map<String, String> params);

	// 상세조회
	PlaceOrderOverviewDetailDTO findDetailByPoId(SqlSession sqlSession, int poId);
	List<PlaceOrderOverviewMaterialDTO> findDetailItemsByPoId(SqlSession sqlSession, int poId);

	// 메인페이지 발주 수
	Integer selectPendingCnt() throws Exception;
}
