package service.branch.inbound;

import java.util.List;

import dto.branch.inbound.InboundHistoryDTO;

public interface InboundHistoryService {

    List<InboundHistoryDTO> getInboundHistoryList(int branchCode, String startDate, String endDate);

    InboundHistoryDTO getInboundHistoryDetail(int branchCode, String poNo);
}