package service.branch.place_order;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.ibatis.session.SqlSession;

import dao.branch.place_order.PlaceOrderDAO;
import dao.branch.place_order.PlaceOrderDAOImpl;
import dao.branch.place_order.PlaceOrderDraftDAO;
import dao.branch.place_order.PlaceOrderDraftDAOImpl;
import dto.branch.place_order.PlaceOrderDTO;
import dto.branch.place_order.PlaceOrderDetailDTO;
import dto.branch.place_order.PlaceOrderDraftDTO;
import dto.branch.place_order.PlaceOrderDraftDetailDTO;
import util.MyBatisSqlSessionFactory;

public class PlaceOrderSendServiceImpl implements PlaceOrderSendService {

	private final PlaceOrderDraftDAO draftDAO = new PlaceOrderDraftDAOImpl();
	private final PlaceOrderDAO placeOrderDAO = new PlaceOrderDAOImpl();

	@Override
	public boolean sendDraft(int branchCode) {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
		try {
			// branchCode 지점의 IN_PROGRESS 상태의 임시 발주서(Draft) 조회
			PlaceOrderDraftDTO draftDTO = draftDAO.findInProgressDraft(sqlSession, branchCode);
			validateDraft(draftDTO);

			// 조회한 Draft의 DraftDetails 꺼내오기
			Integer draftId = draftDTO.getDraftId();
			List<PlaceOrderDraftDetailDTO> draftDetailDTOs = draftDAO.findDraftDetails(sqlSession, draftId);
			validateDraftDetails(draftDetailDTOs);

			// draft에 draftDetails 연결
			draftDTO.setDetails(draftDetailDTOs);

			int totalCnt = draftDetailDTOs.size();
			int totalAmount = draftDetailDTOs.stream().mapToInt(d -> d.getRequestedQty().intValue()).sum();
			// 발주 DTO 생성
			PlaceOrderDTO placeOrderDTO = new PlaceOrderDTO();
			placeOrderDTO.setBranchCode(draftDTO.getBranchCode());
			placeOrderDTO.setPoNo("TEMP_PoNo");
			placeOrderDTO.setTotalMaterialCnt(totalCnt);
			placeOrderDTO.setTotalAmount(totalAmount);

			// 발주 처리 - place_order 테이블에 데이터 생성
			// DB에서 주는 발주서 번호 반환
			placeOrderDAO.insertPlaceOrder(sqlSession, placeOrderDTO);
			Integer poId = placeOrderDTO.getPoId(); // MyBatis - useGeneratedKeys로 인해 DTO에 id를 가져나옴
			
			// 발주 처리 - 상세 내역 데이터 삽입
			List<PlaceOrderDetailDTO> poDetailDTOs = convertToPlaceOrderDetails(draftDetailDTOs);
			Integer insertedPODetailCnt = placeOrderDAO.insertPlaceOrderDetails(sqlSession, poId,  poDetailDTOs);

			// 발주서 번호를 규칙에 맞게 UPDATE (DB에서 AUTO_INCREMENT된 poNo 변경)
			String ruledPoNo = generatePoNo(poId);
			placeOrderDAO.updatePlaceOrderNo(sqlSession, poId, ruledPoNo);

			// 임시 발주서(Draft)를 발주 완료(COMPLETED) 상태로 변경
			String newStatus = "COMPLETED";
			draftDAO.updateDraftStatusAfterSend(sqlSession, draftDTO.getDraftId(), placeOrderDTO.getPoId(), newStatus);

			// 임시 발주서 상세 (DraftDetails) 삭제
			int deletedCnt = draftDAO.deleteDraftDetails(sqlSession, draftDTO.getDraftId());
			if (deletedCnt <= 0)
				throw new Exception("");

			sqlSession.commit();
			return true;

		} catch (Exception e) {
			sqlSession.rollback();
			throw new RuntimeException(e);

		} finally {
			sqlSession.close();
		}
	}

	// =====================================
	// ============ private ================
	// =====================================

	// 유효 검사) 임시저장된 발주서
	private void validateDraft(PlaceOrderDraftDTO draftDTO) {
		if (draftDTO == null) {
			throw new IllegalStateException("진행중인 발주서가 없습니다.");
		}

		if (draftDTO.getDraftId() == null) {
			throw new IllegalStateException("draft_id 누락");
		}

		if (draftDTO.getBranchCode() == null) {
			throw new IllegalStateException("branch_code 누락");
		}

		if (!"IN_PROGRESS".equals(draftDTO.getStatus())) {
			throw new IllegalStateException("진행중 상태의 발주서가 아닙니다.");
		}
	}

	// 유효 검사) 임시저장된 발주서의 상세
	private void validateDraftDetails(List<PlaceOrderDraftDetailDTO> detailDTOs) {
		if (detailDTOs == null || detailDTOs.isEmpty()) {
			throw new IllegalStateException("발주 상세가 없습니다.");
		}

		for (PlaceOrderDraftDetailDTO detail : detailDTOs) {
			if (detail == null)
				continue;

			if (detail.getMaterialCode() == null || detail.getMaterialCode().isBlank()) {
				throw new IllegalStateException("material_code 누락");
			}

			if (detail.getRequestedQty() == null) {
				throw new IllegalStateException("요청 수량 누락");
			}

			if (detail.getRequestedQty() <= 0) {
				throw new IllegalStateException("요청 수량은 0보다 커야 합니다.");
			}
		}
	}

	// 발주서 번호 생성 (규칙)
	private String generatePoNo(Integer poId) {
		String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmm"));
		return "PO-" + time + "-" + String.format("%d", poId);
	}
	
	// 임시발주상세 -> 발주상세로 전환
	private List<PlaceOrderDetailDTO> convertToPlaceOrderDetails(List<PlaceOrderDraftDetailDTO> draftDetails) {
	    return draftDetails.stream()
	        .map(d -> {
	            PlaceOrderDetailDTO od = new PlaceOrderDetailDTO();
	            od.setMaterialCode(d.getMaterialCode());
	            od.setRequestedQty(d.getRequestedQty());
	            od.setApprovedQty(0);
	            od.setRemainingQty(0);
	            return od;
	        })
	        .collect(Collectors.toList());
	}
}
