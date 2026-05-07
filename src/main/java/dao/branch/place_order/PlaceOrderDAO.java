package dao.branch.place_order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.branch.place_order.PlaceOrderDetailDTO;
import dto.branch.place_order.PlaceOrderDraftDetailDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.NotificationDTO;
import dto.NotificationReceiverDTO;
import dto.branch.place_order.PlaceOrderDTO;

public interface PlaceOrderDAO {

	//발주 이력 목록을 조회
    List<PlaceOrderHistoryDTO> selectPlaceOrderHistory(SqlSession sqlSession, Map<String, Object> queryParams);

    // 발주서 번호 기준의 단건 이력을 조회
    PlaceOrderHistoryDTO selectPlaceOrderDetail(SqlSession sqlSession, String poNo);

    // 발주서 번호 기준의 품목 상세 목록을 조회
    List<PlaceOrderDetailDTO> selectPlaceOrderDetails(SqlSession sqlSession, String poNo);

    // 발주서 생성
    int insertPlaceOrder(SqlSession sqlSession, PlaceOrderDTO placeOrderDTO);
    
    // 발주서 조회
    PlaceOrderDTO findPlaceOrder(SqlSession sqlSession, String poNo);
    
    // 발주서 번호 조회
    String findPlaceOrderNo(SqlSession sqlSession, int placeOrderId);

    // 발주서의 품목 상세 생성
	Integer insertPlaceOrderDetails(SqlSession sqlSession, Integer poId, List<PlaceOrderDetailDTO> draftDetailDTOs);
	
    // 발주서 상태 갱신
	int updatePlaceOrderStatus(SqlSession sqlSession, String poNo, String status);
	// 발주 취소(상태도 갱신)
    int updatePlaceOrderStatusCancel(SqlSession sqlSession, String poNo, String cancelReason);
    
    // 발주서 번호 (pONo) 변경
	int updatePlaceOrderNo(SqlSession sqlSession, Integer poId, String poNo);

	String findBranchName(SqlSession sqlSession, Integer branchCode);

	// 알림 생성
	int insertNotification(SqlSession sqlSession, NotificationDTO dto);

	// 본사 소속 계정들 조회
	List<Integer> selectHqAccountIds(SqlSession sqlSession);
	
	// 알림 수신자 생성
	void insertNotifiReceiver(SqlSession sqlSession, NotificationReceiverDTO receiver);
}
