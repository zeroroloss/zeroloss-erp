package service.branch.place_order;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.branch.place_order.PlaceOrderDAO;
import dao.branch.place_order.PlaceOrderDAOImpl;
import dto.branch.place_order.PlaceOrderDetailDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.branch.place_order.PlaceOrderRequestDTO;

public class PlaceOrderServiceImpl implements PlaceOrderService {

    private static final String CONTEXT_PATH = "/zeroloss"; // 애플리케이션 공통 contextPath
    private static final String STATUS_PENDING = "PENDING"; // 전송 상태 코드
    private static final String STATUS_APPROVED = "APPROVED"; // 승인 상태 코드
    private static final String STATUS_REJECTED = "REJECTED"; // 반려 상태 코드
    private static final String STATUS_KEY_SENT = "전송"; // 전송 상태 한글 키
    private static final String STATUS_KEY_APPROVED = "승인"; // 승인 상태 한글 키
    private static final String STATUS_KEY_REJECTED = "반려"; // 반려 상태 한글 키
    private static final String PAGE_REQUEST_DETAIL = "request_detail.jsp"; // 전송 상세 페이지
    private static final String PAGE_APPROVAL_DETAIL = "approval_detail.jsp"; // 승인 상세 페이지
    private static final String PAGE_REJECTION_DETAIL = "rejection_detail.jsp"; // 반려 상세 페이지
    private static final String PAGE_CANCEL_REQUEST = "cancel_request.jsp"; // 취소 요청 페이지

    private static final DateTimeFormatter PO_NO_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS"); // 발주번호 생성 포맷

    private final PlaceOrderDAO placeOrderDAO = new PlaceOrderDAOImpl(); // DAO 인스턴스 생성

    @Override
    public List<PlaceOrderHistoryDTO> getPlaceOrderHistoryList(int branchCode, String startDate, String endDate, String status) {
        Map<String, Object> params = new HashMap<>(); // DAO로 전달할 파라미터 맵 생성
        params.put("branchCode", branchCode); // 지점 코드 설정
        params.put("startDate", startDate); // 시작일 설정
        params.put("endDate", endDate); // 종료일 설정
        params.put("status", status); // 상태 필터 설정
        params.put("contextPath", CONTEXT_PATH); // contextPath 전달

     // 발주 내역 조회 (품목 상세 포함됨)
        List<PlaceOrderHistoryDTO> historyList = placeOrderDAO.selectPlaceOrderHistory(params); 
        if (historyList == null) {
            return Collections.emptyList(); // null이면 빈 리스트 반환
        }

        for (PlaceOrderHistoryDTO historyDTO : historyList) {
            normalizeHistory(historyDTO, CONTEXT_PATH); // 각 DTO 데이터 정규화
        }
        return historyList; 
    }

    @Override
    public PlaceOrderHistoryDTO getPlaceOrderDetail(String poNo) {
        PlaceOrderHistoryDTO history = placeOrderDAO.selectPlaceOrderDetail(poNo); // 단건 발주 조회
        if (history == null) {
            return null; // 없으면 null 반환
        }

        List<PlaceOrderDetailDTO> details = placeOrderDAO.selectPlaceOrderDetails(poNo); // 상세 품목 조회
        if (details != null) {
            for (PlaceOrderDetailDTO detail : details) {
                if (detail == null) {
                    continue; // null 방어
                }

                BigDecimal requested = detail.getRequestedQty(); // 요청 수량
                if (requested == null) {
                    requested = BigDecimal.ZERO; // null이면 0으로 초기화
                    detail.setRequestedQty(requested);
                }

                BigDecimal approved = detail.getApprovedQty(); // 승인 수량
                if (approved == null) {
                    approved = STATUS_APPROVED.equals(history.getStatusCode()) ? requested : BigDecimal.ZERO; // 승인 상태면 요청수량, 아니면 0
                    detail.setApprovedQty(approved);
                }

                BigDecimal remaining = detail.getRemainingQty(); // 잔여 수량
                if (remaining == null) {
                    remaining = requested.subtract(approved); // 요청 - 승인
                    if (remaining.compareTo(BigDecimal.ZERO) < 0) {
                        remaining = BigDecimal.ZERO; // 음수 방지
                    }
                    detail.setRemainingQty(remaining);
                }
            }
        }
        history.setDetails(details != null ? details : Collections.emptyList()); // 상세 리스트 세팅
        normalizeHistory(history, CONTEXT_PATH); // 공통 필드 정규화
        return history; // 반환
    }

    @Override
    public boolean createPlaceOrder(PlaceOrderRequestDTO requestDTO) {
        if (requestDTO == null) {
            throw new IllegalArgumentException("발주 데이터가 비어있습니다."); // null 방어
        }

        if (!hasText(requestDTO.getPoNo())) {
            requestDTO.setPoNo("PO-" + LocalDateTime.now().format(PO_NO_FORMATTER)); // 발주번호 생성
        }
        if (!hasText(requestDTO.getStatus())) {
            requestDTO.setStatus(STATUS_PENDING); // 기본 상태 설정
        }

        int orderRows = placeOrderDAO.insertPlaceOrder(requestDTO); // 발주 insert
        if (orderRows == 0 || requestDTO.getPoId() == null) {
            return false; // 실패 조건
        }

        if (requestDTO.getDetails() != null && !requestDTO.getDetails().isEmpty()) {
            placeOrderDAO.insertPlaceOrderDetails(requestDTO.getPoId(), requestDTO.getDetails()); // 상세 insert
        }
        return true; // 성공
    }

    @Override
    public boolean updatePlaceOrderStatus(String poNo, String status, String rejectReason) {
        Map<String, Object> params = new HashMap<>(); // 파라미터 맵 생성
        params.put("poNo", poNo); // 발주번호
        params.put("status", status); // 상태
        params.put("rejectReason", rejectReason); // 반려 사유
        return placeOrderDAO.updatePlaceOrderStatus(params) > 0; // 업데이트 결과 반환
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

        if (!STATUS_KEY_SENT.equals(statusKey)
                && !STATUS_KEY_APPROVED.equals(statusKey)
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
}