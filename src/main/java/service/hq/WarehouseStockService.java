package service.hq;

import java.util.List;
import java.util.Map;

import dto.hq.warehouse.WarehouseStockResultDTO;
import dto.hq.warehouse.WarehouseStockSearchDTO;

public interface WarehouseStockService {

	List<WarehouseStockResultDTO> searchList(WarehouseStockSearchDTO searchDTO);
	Map<String, List<String>> getCategoryMaterialMap();

}
