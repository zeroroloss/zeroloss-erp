package dto.hq.place_order;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class PlaceOrderProcessingDetailDTO {

    private Integer poDetailId;
    private Integer poId;
    private String materialCode;
    private String materialName;
    private String unit;
    private Integer requestedQty;
    private Integer approvedQty;
    private Integer remainingQty;
    private Integer currentBranchStock;
    private Integer safeStockQty;

    public static List<PlaceOrderProcessingDetailDTO> from(Object rawDetails) {
        List<PlaceOrderProcessingDetailDTO> details = new ArrayList<>();
        if (!(rawDetails instanceof List)) {
            return details;
        }

        List<?> rows = (List<?>) rawDetails;
        for (Object row : rows) {
            if (!(row instanceof Map)) {
                continue;
            }
            Map<?, ?> map = (Map<?, ?>) row;
            PlaceOrderProcessingDetailDTO dto = new PlaceOrderProcessingDetailDTO();
            dto.setPoDetailId(asInt(map.get("poDetailId")));
            dto.setApprovedQty(asInt(map.get("approvedQty")));
            details.add(dto);
        }

        return details;
    }

    private static Integer asInt(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        return Integer.parseInt(String.valueOf(value));
    }

    public Integer getPoDetailId() {
        return poDetailId;
    }

    public void setPoDetailId(Integer poDetailId) {
        this.poDetailId = poDetailId;
    }

    public Integer getPoId() {
        return poId;
    }

    public void setPoId(Integer poId) {
        this.poId = poId;
    }

    public String getMaterialCode() {
        return materialCode;
    }

    public void setMaterialCode(String materialCode) {
        this.materialCode = materialCode;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public Integer getRequestedQty() {
        return requestedQty;
    }

    public void setRequestedQty(Integer requestedQty) {
        this.requestedQty = requestedQty;
    }

    public Integer getApprovedQty() {
        return approvedQty;
    }

    public void setApprovedQty(Integer approvedQty) {
        this.approvedQty = approvedQty;
    }

    public Integer getRemainingQty() {
        return remainingQty;
    }

    public void setRemainingQty(Integer remainingQty) {
        this.remainingQty = remainingQty;
    }

    public Integer getCurrentBranchStock() {
        return currentBranchStock;
    }

    public void setCurrentBranchStock(Integer currentBranchStock) {
        this.currentBranchStock = currentBranchStock;
    }

    public Integer getSafeStockQty() {
        return safeStockQty;
    }

    public void setSafeStockQty(Integer safeStockQty) {
        this.safeStockQty = safeStockQty;
    }
}
