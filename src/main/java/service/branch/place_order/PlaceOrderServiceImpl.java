package service.branch.place_order;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.ibatis.session.SqlSession;

import dao.branch.place_order.PlaceOrderDAO;
import dao.branch.place_order.PlaceOrderDAOImpl;
import dao.branch.place_order.PlaceOrderDraftDAO;
import dao.branch.place_order.PlaceOrderDraftDAOImpl;
import dto.branch.place_order.PlaceOrderDetailDTO;
import dto.branch.place_order.PlaceOrderDraftDTO;
import dto.branch.place_order.PlaceOrderDraftDetailDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.branch.place_order.PlaceOrderDTO;
import util.MyBatisSqlSessionFactory;

public class PlaceOrderServiceImpl implements PlaceOrderService {

	private static final String CONTEXT_PATH = "/zeroloss"; // 애플리케이션 공통 contextPath

	private static final String STATUS_PENDING = "PENDING"; // 전송 상태
	private static final String STATUS_APPROVED = "APPROVED"; // 승인 상태
	private static final String STATUS_REJECTED = "REJECTED"; // 반려 상태

	private static final String STATUS_KEY_SENT = "전송";
	private static final String STATUS_KEY_APPROVED = "승인";
	private static final String STATUS_KEY_REJECTED = "반려";

	private static final String PAGE_REQUEST_DETAIL = "request_detail.jsp"; // 전송 상세 페이지
	private static final String PAGE_APPROVAL_DETAIL = "approval_detail.jsp"; // 승인 상세 페이지
	private static final String PAGE_REJECTION_DETAIL = "rejection_detail.jsp"; // 반려 상세 페이지
	private static final String PAGE_CANCEL_REQUEST = "cancel_request.jsp"; // 취소 요청 페이지

	private final PlaceOrderDAO placeOrderDAO = new PlaceOrderDAOImpl(); // DAO 인스턴스 생성
	private final PlaceOrderDraftDAO draftDAO = new PlaceOrderDraftDAOImpl();

	@Override
	public List<PlaceOrderHistoryDTO> getPlaceOrderHistoryList(int branchCode, String startDate, String endDate,
			String status) {

		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			Map<String, Object> params = new HashMap<>(); // DAO로 전달할 파라미터 맵 생성
			params.put("branchCode", branchCode); // 지점 코드 설정
			params.put("startDate", startDate); // 시작일 설정
			params.put("endDate", endDate); // 종료일 설정
			params.put("status", status); // 상태 필터 설정
			params.put("contextPath", CONTEXT_PATH); // contextPath 전달

			// 발주 내역 조회 (품목 상세 포함됨)
			List<PlaceOrderHistoryDTO> historyList = placeOrderDAO.selectPlaceOrderHistory(sqlSession, params);
			if (historyList == null) {
				return Collections.emptyList(); // null이면 빈 리스트 반환
			}

			for (PlaceOrderHistoryDTO historyDTO : historyList) {
				normalizeHistory(historyDTO, CONTEXT_PATH); // 각 DTO 데이터 정규화
			}
			return historyList;
		} catch (Exception e) {
			throw e;
		}

	}

	@Override
	public PlaceOrderHistoryDTO getPlaceOrderDetail(String poNo) {
		
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
		
		try {
			 // 1) 단건 조회
		    PlaceOrderHistoryDTO history = placeOrderDAO.selectPlaceOrderDetail(sqlSession, poNo);
		    if (history == null) {
		        return null;
		    }

		    // 2) 상세 조회
		    List<PlaceOrderDetailDTO> details = placeOrderDAO.selectPlaceOrderDetails(sqlSession, poNo);

		    if (details != null) {
		        for (PlaceOrderDetailDTO detail : details) {
		            if (detail == null) continue;

		            // 요청 수량
		            BigDecimal requested = detail.getRequestedQty();
		            if (requested == null) {
		                requested = BigDecimal.ZERO;
		                detail.setRequestedQty(requested);
		            }

		            // 승인 수량
		            BigDecimal approved = detail.getApprovedQty();
		            if (approved == null) {
		                approved = STATUS_APPROVED.equals(history.getStatusCode())
		                        ? requested
		                        : BigDecimal.ZERO;
		                detail.setApprovedQty(approved);
		            }

		            // 잔여 수량
		            BigDecimal remaining = detail.getRemainingQty();
		            if (remaining == null) {
		                remaining = requested.subtract(approved);
		                if (remaining.compareTo(BigDecimal.ZERO) < 0) {
		                    remaining = BigDecimal.ZERO;
		                }
		                detail.setRemainingQty(remaining);
		            }
		        }
		    }

		    // 3) 상세 세팅
		    history.setDetails(details != null ? details : Collections.emptyList());

		    // 4) 공통 정규화
		    normalizeHistory(history, CONTEXT_PATH);

		    return history;
		} catch (Exception e) {
			sqlSession.rollback();
			throw new RuntimeException(e);
		}
	   
	}



	private boolean hasText(String value) {
		return value != null && !value.isBlank(); // null 및 공백 체크
	}

	// FE에서 사용하기 좋게 정규화
	private void normalizeHistory(PlaceOrderHistoryDTO historyDTO, String contextPath) {
		if (historyDTO == null) {
			return;
		}

		// 상태값 정규화
		String statusCode = historyDTO.getStatusCode(); // 상태 코드
		String statusKey = historyDTO.getStatus(); // 상태 한글

		if (!STATUS_KEY_SENT.equals(statusKey) && !STATUS_KEY_APPROVED.equals(statusKey)
				&& !STATUS_KEY_REJECTED.equals(statusKey)) {
			if (STATUS_APPROVED.equals(statusCode)) {
				statusKey = STATUS_KEY_APPROVED; // 승인
			} else if (STATUS_REJECTED.equals(statusCode)) {
				statusKey = STATUS_KEY_REJECTED; // 반려
			} else {
				statusKey = STATUS_KEY_SENT; // 전송
			}
		}

		if (!hasText(statusCode)) {
			if (STATUS_KEY_APPROVED.equals(statusKey)) {
				statusCode = STATUS_APPROVED; // 코드 보정
			} else if (STATUS_KEY_REJECTED.equals(statusKey)) {
				statusCode = STATUS_REJECTED;
			} else {
				statusCode = STATUS_PENDING;
			}
		}

		historyDTO.setStatusCode(statusCode); // 상태 코드 세팅
		historyDTO.setStatus(statusKey); // 상태 한글 세팅

		// 날짜 포맷
		if (historyDTO.getCreatedAt() != null && historyDTO.getCreatedAt().length() >= 16) {
			historyDTO.setCreatedAt(historyDTO.getCreatedAt().substring(0, 16));
		}

		// 수량 관련 보정
		if (historyDTO.getItemCount() == null && historyDTO.getTotalMaterialCnt() != null) {
			historyDTO.setItemCount(historyDTO.getTotalMaterialCnt()); // itemCount
		}

		if (historyDTO.getTotalQty() == null) {
			historyDTO.setTotalQty(historyDTO.getTotalMaterialCnt() != null ? historyDTO.getTotalMaterialCnt() : 0); // totalQty
		}

		// URL 생성 분리
		if (!hasText(historyDTO.getDetailUrl())) {
			if (STATUS_APPROVED.equals(statusCode) || STATUS_KEY_APPROVED.equals(statusKey)) {
				historyDTO.setDetailUrl(contextPath + "/branch/place_order/" + PAGE_APPROVAL_DETAIL); // 승인 상세 URL
			} else if (STATUS_REJECTED.equals(statusCode) || STATUS_KEY_REJECTED.equals(statusKey)) {
				historyDTO.setDetailUrl(contextPath + "/branch/place_order/" + PAGE_REJECTION_DETAIL); // 반려 상세 URL
			} else {
				historyDTO.setDetailUrl(contextPath + "/branch/place_order/" + PAGE_REQUEST_DETAIL); // 전송 상세 URL
			}
		}

		if (historyDTO.getCancelUrl() == null && STATUS_PENDING.equals(statusCode)) {
			historyDTO.setCancelUrl(contextPath + "/branch/place_order/" + PAGE_CANCEL_REQUEST); // 취소 URL 설정
		}
	}

	// ==========================
	// 발주서 생성
	// ==========================
	@Override
	public PlaceOrderDraftDTO findOrCreateInProgressDraft(int branchCode) {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
		try {
			PlaceOrderDraftDTO draftDTO = draftDAO.findInProgressDraft(sqlSession, branchCode);
			boolean isNewDraft = false;

			if (draftDTO == null) {
				draftDTO = new PlaceOrderDraftDTO();
				draftDTO.setBranchCode(branchCode);
				draftDTO.setStatus("IN_PROGRESS");
				draftDAO.insertDraft(sqlSession, draftDTO);
				isNewDraft = true;
				
			}

			if (isNewDraft) {
				initializeLowStockDetails(sqlSession, branchCode, draftDTO);
				System.out.println("New Draft ID = " + draftDTO.getDraftId());
			} else {
				// 기존의 DraftDetails 가져와 연결하기
				draftDTO.setDetails(draftDAO.findDraftDetails(sqlSession, draftDTO.getDraftId()));
				System.out.println("Existing Draft ID = " + draftDTO.getDraftId());
			}

			// 커밋
			sqlSession.commit();
			return draftDTO;

		} catch (Exception e) {
			sqlSession.rollback();
			throw new RuntimeException(e);
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public boolean updatePlaceOrderDraftDetail(int branchCode, String action, PlaceOrderDraftDetailDTO detailDTO) {
		if (!hasText(action)) {
			throw new IllegalArgumentException("발주 처리 유형이 필요합니다.");
		}
		if (detailDTO == null || !hasText(detailDTO.getMaterialCode())) {
			throw new IllegalArgumentException("품목 정보가 비어있습니다.");
		}

		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);

		try {
			PlaceOrderDraftDTO draftDTO = ensureInProgressDraft(sqlSession, branchCode);
			int draftId = draftDTO.getDraftId();
			String normalizedAction = action.trim().toLowerCase();

			if ("add".equals(normalizedAction)) {
				// place_order_draft_detail에 추가
				PlaceOrderDraftDetailDTO payload = buildDraftDetailPayload(draftId, detailDTO);
				draftDAO.insertDraftDetail(sqlSession, payload);

			} else if ("remove".equals(normalizedAction)) {
				// place_order_draft_detail에서 제외
				draftDAO.deleteDraftDetails(sqlSession, draftId, detailDTO.getMaterialCode());

			} else if ("update-qty".equals(normalizedAction) || "updateqty".equals(normalizedAction)
					|| "update".equals(normalizedAction)) {
				// 요청수량 변경
				Integer qty = detailDTO.getRequestedQty() != null ? detailDTO.getRequestedQty() : 0;
				draftDAO.updateDraftDetailQty(sqlSession, draftId, detailDTO.getMaterialCode(), qty);

			} else {
				throw new IllegalArgumentException("지원하지 않는 발주 처리 유형입니다.");
			}

			sqlSession.commit();
			return true;
		} catch (Exception e) {
			sqlSession.rollback();
			throw new RuntimeException(e);
		} finally {
			sqlSession.close();
		}
	}

	private PlaceOrderDraftDTO ensureInProgressDraft(SqlSession sqlSession, int branchCode) {
		// InProgress상태의 임시 발주서 가져오기
		PlaceOrderDraftDTO draftDTO = draftDAO.findInProgressDraft(sqlSession, branchCode);
		if (draftDTO != null) {
			return draftDTO;
		}

		// 없으면 생성
		draftDTO = new PlaceOrderDraftDTO();
		draftDTO.setBranchCode(branchCode);
		draftDTO.setStatus("IN_PROGRESS");
		draftDAO.insertDraft(sqlSession, draftDTO);
		return draftDTO;
	}

	private void initializeLowStockDetails(SqlSession sqlSession, int branchCode, PlaceOrderDraftDTO draftDTO) {
		if (draftDTO == null || draftDTO.getDraftId() <= 0) {
			return;
		}

		List<PlaceOrderDraftDetailDTO> existingDetails = draftDAO.findDraftDetails(sqlSession, draftDTO.getDraftId());
		List<PlaceOrderDraftDetailDTO> lowStockMaterials = draftDAO.findLowStockMaterials(sqlSession, branchCode);

		for (PlaceOrderDraftDetailDTO lowStock : lowStockMaterials) {
			boolean exists = existingDetails.stream()
					.anyMatch(detail -> detail.getMaterialCode().equals(lowStock.getMaterialCode()));

			if (!exists) {
				lowStock.setDraftId(draftDTO.getDraftId());
				lowStock.setSourceType("LOW_STOCK");
				lowStock.setRequestedQty(defaultRequestedQty(lowStock));
				draftDAO.insertDraftDetail(sqlSession, lowStock);
			}
		}

		draftDTO.setDetails(draftDAO.findDraftDetails(sqlSession, draftDTO.getDraftId()));
	}

	private PlaceOrderDraftDetailDTO buildDraftDetailPayload(int draftId, PlaceOrderDraftDetailDTO detailDTO) {
		PlaceOrderDraftDetailDTO payload = new PlaceOrderDraftDetailDTO();
		payload.setDraftId(draftId);
		payload.setMaterialCode(detailDTO.getMaterialCode());
		payload.setMaterialName(detailDTO.getMaterialName());
		payload.setCategoryName(detailDTO.getCategoryName());
		payload.setUnit(detailDTO.getUnit());
		payload.setCurrentStock(detailDTO.getCurrentStock());
		payload.setSafeStock(detailDTO.getSafeStock());
		payload.setSourceType(hasText(detailDTO.getSourceType()) ? detailDTO.getSourceType() : "MANUAL");
		payload.setRequestedQty(
				detailDTO.getRequestedQty() != null ? detailDTO.getRequestedQty() : defaultRequestedQty(detailDTO));
		return payload;
	}

	private int defaultRequestedQty(PlaceOrderDraftDetailDTO detailDTO) {
		// 기본 요청수량을 안전재고 양으로 변경 (요청: 기본값 = safeStock)
		int safeStock = detailDTO != null && detailDTO.getSafeStock() != null ? detailDTO.getSafeStock() : 0;
		return Math.max(0, safeStock);
	}

	@Override
	public List<Map<String, Object>> getSelectableItems(int branchCode, String category, String item, String search) {

		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);

		try {
			// 1. draft 확보 (없으면 생성)
			PlaceOrderDraftDTO draftDTO = findOrCreateInProgressDraft(branchCode);
			int draftId = draftDTO.getDraftId();

			// 2. 전체 조회
			List<Map<String, Object>> list = draftDAO.findSelectableItems(sqlSession, branchCode, draftId);

			if (list == null || list.isEmpty()) {
				return Collections.emptyList();
			}

			// 3. 필터링
			return list.stream().filter(row -> {

				String categoryName = (String) row.get("categoryName");
				String materialName = (String) row.get("materialName");
				String materialCode = (String) row.get("materialCode");

				// 카테고리 필터
				if (hasText(category) && !"전체".equals(category)) {
					if (categoryName == null || !categoryName.equals(category)) {
						return false;
					}
				}

				// 품목 필터
				if (hasText(item) && !"전체".equals(item)) {
					if (materialName == null || !materialName.equals(item)) {
						return false;
					}
				}

				// 검색 필터
				if (hasText(search)) {
					String keyword = search.toLowerCase();

					boolean match = (materialCode != null && materialCode.toLowerCase().contains(keyword))
							|| (materialName != null && materialName.toLowerCase().contains(keyword))
							|| (categoryName != null && categoryName.toLowerCase().contains(keyword));

					if (!match) {
						return false;
					}
				}

				return true;
			}).collect(Collectors.toList());

		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public int getLowStockTotalCount(int branchCode) {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
		try {
			return draftDAO.countLowStockMaterials(sqlSession, branchCode);
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public boolean createPlaceOrder(PlaceOrderDTO requestDTO) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean updatePlaceOrderStatus(String poNo, String status, String rejectReason) {
		// TODO Auto-generated method stub
		return false;
	}

}