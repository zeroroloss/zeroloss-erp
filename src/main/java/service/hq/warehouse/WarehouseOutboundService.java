package service.hq.warehouse;

import java.util.List;
import java.util.Map;

import dto.hq.warehouse.WarehouseOutboundDTO;
import dto.hq.warehouse.WarehouseOutboundDetailDTO;

public interface WarehouseOutboundService {
    List<String> findAllBranchNames();

    List<WarehouseOutboundDTO> findOutbounds(Map<String, String> params);

    WarehouseOutboundDetailDTO findDetailByOutboundNo(int outboundNo);
}
