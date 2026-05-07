package dto.hq.warehouse;

/**
 * 유통기한 임박 상품 정보 DTO
 */
public class ExpiryItemDTO {
    private Integer id;                 // warehouse_stock id
    private String stockNo;             // 재고 코드
    private String itemCode;            // 품목 코드
    private String category;            // 카테고리명
    private String itemName;            // 품목명
    private Integer quantity;           // 수량
    private String unit;                // 단위
    private String receivedDate;        // 입고일 (YYYY-MM-DD)
    private String expiryDate;          // 유통기한 (YYYY-MM-DD)
    private Integer daysLeft;           // D-Day (남은 일수)
    private Integer unitPrice;          // 단가
    private Integer totalValue;         // 자산 가치 (수량 * 단가)
    private String status;              // 상태 (urgent: 1일 이내, warning: 3일 이내, normal: 그 외)

    public ExpiryItemDTO() {}

    public ExpiryItemDTO(Integer id, String stockNo, String itemCode, String category, String itemName,
                         Integer quantity, String unit, String receivedDate, String expiryDate,
                         Integer daysLeft, Integer unitPrice, Integer totalValue, String status) {
        this.id = id;
        this.stockNo = stockNo;
        this.itemCode = itemCode;
        this.category = category;
        this.itemName = itemName;
        this.quantity = quantity;
        this.unit = unit;
        this.receivedDate = receivedDate;
        this.expiryDate = expiryDate;
        this.daysLeft = daysLeft;
        this.unitPrice = unitPrice;
        this.totalValue = totalValue;
        this.status = status;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getStockNo() {
        return stockNo;
    }

    public void setStockNo(String stockNo) {
        this.stockNo = stockNo;
    }

    public String getItemCode() {
        return itemCode;
    }

    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getReceivedDate() {
        return receivedDate;
    }

    public void setReceivedDate(String receivedDate) {
        this.receivedDate = receivedDate;
    }

    public String getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(String expiryDate) {
        this.expiryDate = expiryDate;
    }

    public Integer getDaysLeft() {
        return daysLeft;
    }

    public void setDaysLeft(Integer daysLeft) {
        this.daysLeft = daysLeft;
    }

    public Integer getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(Integer unitPrice) {
        this.unitPrice = unitPrice;
    }

    public Integer getTotalValue() {
        return totalValue;
    }

    public void setTotalValue(Integer totalValue) {
        this.totalValue = totalValue;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "ExpiryItemDTO{" +
                "id=" + id +
                ", stockNo='" + stockNo + '\'' +
                ", itemCode='" + itemCode + '\'' +
                ", category='" + category + '\'' +
                ", itemName='" + itemName + '\'' +
                ", quantity=" + quantity +
                ", unit='" + unit + '\'' +
                ", receivedDate='" + receivedDate + '\'' +
                ", expiryDate='" + expiryDate + '\'' +
                ", daysLeft=" + daysLeft +
                ", unitPrice=" + unitPrice +
                ", totalValue=" + totalValue +
                ", status='" + status + '\'' +
                '}';
    }
}
