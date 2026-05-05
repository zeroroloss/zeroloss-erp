package dto.branch.inbound;

import java.math.BigDecimal;

public class InboundHistoryItemDTO {

    private String branchStockCode;
    private String categoryName;
    private String materialName;
    private BigDecimal receivedQty;
    private String unit;

    public String getBranchStockCode() {
        return branchStockCode;
    }

    public void setBranchStockCode(String branchStockCode) {
        this.branchStockCode = branchStockCode;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public BigDecimal getReceivedQty() {
        return receivedQty;
    }

    public void setReceivedQty(BigDecimal receivedQty) {
        this.receivedQty = receivedQty;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    @Override
    public String toString() {
        return "InboundHistoryItemDTO [branchStockCode=" + branchStockCode + ", categoryName=" + categoryName
                + ", materialName=" + materialName + ", receivedQty=" + receivedQty + ", unit=" + unit + "]";
    }
}