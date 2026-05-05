package service.branch.inbound;

import java.util.List;

import dto.branch.inbound.InboundProcessingItemDTO;
import dto.branch.inbound.InboundProcessingDTO;

public interface InboundService {

	List<InboundProcessingDTO> findInboundsToProcess(int branchCode);

	boolean confirmInbound(int branchCode, String poNo, List<InboundProcessingItemDTO> items);

}
