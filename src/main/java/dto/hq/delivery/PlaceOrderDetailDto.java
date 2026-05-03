package dto.hq.delivery;

import java.math.BigDecimal;

public class PlaceOrderDetailDto {
    private String materialName;
    private BigDecimal requestedQty;
    private BigDecimal approvedQty;
    private String unit;

    // Getters and Setters
    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }
    public BigDecimal getRequestedQty() { return requestedQty; }
    public void setRequestedQty(BigDecimal requestedQty) { this.requestedQty = requestedQty; }
    public BigDecimal getApprovedQty() { return approvedQty; }
    public void setApprovedQty(BigDecimal approvedQty) { this.approvedQty = approvedQty; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
}
