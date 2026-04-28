package dto.branch.place_order;

import java.io.Serializable;
import java.math.BigDecimal;

public class PlaceOrderRequestDetailDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String materialCode;
    private BigDecimal requestedQty;
    private BigDecimal approvedQty;
    private BigDecimal remainingQty;

    public String getMaterialCode() {
        return materialCode;
    }

    public void setMaterialCode(String materialCode) {
        this.materialCode = materialCode;
    }

    public BigDecimal getRequestedQty() {
        return requestedQty;
    }

    public void setRequestedQty(BigDecimal requestedQty) {
        this.requestedQty = requestedQty;
    }

    public BigDecimal getApprovedQty() {
        return approvedQty;
    }

    public void setApprovedQty(BigDecimal approvedQty) {
        this.approvedQty = approvedQty;
    }

    public BigDecimal getRemainingQty() {
        return remainingQty;
    }

    public void setRemainingQty(BigDecimal remainingQty) {
        this.remainingQty = remainingQty;
    }
}