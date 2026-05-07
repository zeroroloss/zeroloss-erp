package dto.hq.warehouse;

import java.util.List;

/**
 * 폐기 처리 요청 DTO
 */
public class DisposalRequestDTO {
    private List<String> stockNos;  // 폐기할 재고 코드 목록
    private String reason;          // 폐기 사유 (선택, 기본값: ETC)
    private String reasonDetail;    // 폐기 상세 사유 (선택)

    public DisposalRequestDTO() {
        this.reason = "ETC";  // 기본값
    }

    public DisposalRequestDTO(List<String> stockNos) {
        this.stockNos = stockNos;
        this.reason = "ETC";
    }

    public DisposalRequestDTO(List<String> stockNos, String reason, String reasonDetail) {
        this.stockNos = stockNos;
        this.reason = reason;
        this.reasonDetail = reasonDetail;
    }

    public List<String> getStockNos() {
        return stockNos;
    }

    public void setStockNos(List<String> stockNos) {
        this.stockNos = stockNos;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getReasonDetail() {
        return reasonDetail;
    }

    public void setReasonDetail(String reasonDetail) {
        this.reasonDetail = reasonDetail;
    }

    @Override
    public String toString() {
        return "DisposalRequestDTO{" +
                "stockNos=" + stockNos +
                ", reason='" + reason + '\'' +
                ", reasonDetail='" + reasonDetail + '\'' +
                '}';
    }
}
