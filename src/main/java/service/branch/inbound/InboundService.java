package service.branch.inbound;

import java.util.List;

import dto.branch.inbound.InboundProcessingDTO;

public interface InboundService {

	List<InboundProcessingDTO> findInboundsToProcess();

}
