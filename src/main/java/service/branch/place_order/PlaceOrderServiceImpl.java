package service.branch.place_order;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.branch.place_order.PlaceOrderDAO;
import dao.branch.place_order.PlaceOrderDAOImpl;
import dto.branch.place_order.PlaceOrderDetailDTO;
import dto.branch.place_order.PlaceOrderHistoryDTO;
import dto.branch.place_order.PlaceOrderRequestDTO;
import dto.branch.place_order.PlaceOrderRequestDetailDTO;

public class PlaceOrderServiceImpl implements PlaceOrderService {

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    private static final DateTimeFormatter PO_NO_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS");

    private final PlaceOrderDAO placeOrderDAO = new PlaceOrderDAOImpl();

    @Override
    public List<PlaceOrderHistoryDTO> getPlaceOrderHistory(int branchCode, String startDate, String endDate, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("branchCode", branchCode);
        params.put("startDate", startDate);
        params.put("endDate", endDate);
        params.put("status", status);

        List<PlaceOrderHistoryDTO> historyList = placeOrderDAO.selectPlaceOrderHistory(params);
        if (historyList == null) {
            return new ArrayList<>();
        }

        String contextPath = "/zeroloss-erp";
        for (PlaceOrderHistoryDTO history : historyList) {
            normalizeHistory(history, contextPath);
        }
        return historyList;
    }

    @Override
    public PlaceOrderHistoryDTO getPlaceOrderDetail(String poNo) {
        PlaceOrderHistoryDTO history = placeOrderDAO.selectPlaceOrderDetail(poNo);
        if (history == null) {
            return null;
        }

        List<PlaceOrderDetailDTO> details = placeOrderDAO.selectPlaceOrderDetails(poNo);
        history.setDetails(details != null ? details : new ArrayList<>());
        normalizeHistory(history, "/zeroloss-erp");
        return history;
    }

    @Override
    public boolean createPlaceOrder(PlaceOrderRequestDTO requestDTO) {
        if (requestDTO == null) {
            throw new IllegalArgumentException("발주 데이터가 비어있습니다.");
        }

        if (requestDTO.getPoNo() == null || requestDTO.getPoNo().isBlank()) {
            requestDTO.setPoNo(generatePoNo());
        }
        if (requestDTO.getStatus() == null || requestDTO.getStatus().isBlank()) {
            requestDTO.setStatus("PENDING");
        }

        int orderRows = placeOrderDAO.insertPlaceOrder(requestDTO);
        if (orderRows == 0 || requestDTO.getPoId() == null) {
            return false;
        }

        if (requestDTO.getDetails() != null && !requestDTO.getDetails().isEmpty()) {
            placeOrderDAO.insertPlaceOrderDetails(requestDTO.getPoId(), requestDTO.getDetails());
        }
        return true;
    }

    @Override
    public boolean updatePlaceOrderStatus(String poNo, String status, String rejectReason) {
        Map<String, Object> params = new HashMap<>();
        params.put("poNo", poNo);
        params.put("status", status);
        params.put("rejectReason", rejectReason);
        return placeOrderDAO.updatePlaceOrderStatus(params) > 0;
    }

    private void normalizeHistory(PlaceOrderHistoryDTO history, String contextPath) {
        if (history == null) {
            return;
        }

        if (history.getOrderId() == null) {
            history.setOrderId(history.getPoNo());
        }

        String statusCode = history.getStatusCode();
        String statusKey = toStatusKey(statusCode, history.getStatus());
        history.setStatusCode(statusCode != null ? statusCode : toStatusCode(statusKey));
        history.setStatus(statusKey);
        history.setStatusKey(statusKey);

        if (history.getCreatedAt() != null && history.getCreatedAt().length() >= 16) {
            history.setCreatedAt(history.getCreatedAt().substring(0, 16));
        }

        if (history.getItemCount() == null && history.getTotalMaterialCnt() != null) {
            history.setItemCount(history.getTotalMaterialCnt());
        }

        if (history.getTotalQty() == null) {
            history.setTotalQty(history.getTotalMaterialCnt() != null ? history.getTotalMaterialCnt() : 0);
        }

        if (history.getDetailUrl() == null || history.getDetailUrl().isBlank()) {
            history.setDetailUrl(contextPath + "/branch/place_order/" + getDetailPageName(statusCode, statusKey));
        }

        if (history.getCancelUrl() == null && "PENDING".equals(statusCode)) {
            history.setCancelUrl(contextPath + "/branch/place_order/cancel_request.jsp");
        }
    }

    private String toStatusKey(String statusCode, String currentStatus) {
        if (currentStatus != null && ("전송".equals(currentStatus) || "승인".equals(currentStatus) || "반려".equals(currentStatus))) {
            return currentStatus;
        }
        if ("APPROVED".equals(statusCode)) return "승인";
        if ("REJECTED".equals(statusCode)) return "반려";
        return "전송";
    }

    private String toStatusCode(String statusKey) {
        if ("승인".equals(statusKey)) return "APPROVED";
        if ("반려".equals(statusKey)) return "REJECTED";
        return "PENDING";
    }

    private String getDetailPageName(String statusCode, String statusKey) {
        if ("APPROVED".equals(statusCode) || "승인".equals(statusKey)) {
            return "approval_detail.jsp";
        }
        if ("REJECTED".equals(statusCode) || "반려".equals(statusKey)) {
            return "rejection_detail.jsp";
        }
        return "request_detail.jsp";
    }

    private String generatePoNo() {
        return "PO-" + LocalDateTime.now().format(PO_NO_FORMATTER);
    }
}