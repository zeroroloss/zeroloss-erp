package dto.branch.inbound;

import java.math.BigDecimal;
import java.util.List;

public class InboundHistoryDTO {

    private Integer inboundId;
    private String poNo;
    private String receivedAt;
    private Integer itemCount;
    private BigDecimal totalAmount;
    private List<InboundHistoryItemDTO> items;

    public Integer getInboundId() {
        return inboundId;
    }

    public void setInboundId(Integer inboundId) {
        this.inboundId = inboundId;
    }

    public String getPoNo() {
        return poNo;
    }

    public void setPoNo(String poNo) {
        this.poNo = poNo;
    }

    public String getReceivedAt() {
        return receivedAt;
    }

    public void setReceivedAt(String receivedAt) {
        this.receivedAt = receivedAt;
    }

    public Integer getItemCount() {
        return itemCount;
    }

    public void setItemCount(Integer itemCount) {
        this.itemCount = itemCount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public List<InboundHistoryItemDTO> getItems() {
        return items;
    }

    public void setItems(List<InboundHistoryItemDTO> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "InboundHistoryDTO [inboundId=" + inboundId + ", poNo=" + poNo + ", receivedAt=" + receivedAt
                + ", itemCount=" + itemCount + ", totalAmount=" + totalAmount + ", items=" + items + "]";
    }
}