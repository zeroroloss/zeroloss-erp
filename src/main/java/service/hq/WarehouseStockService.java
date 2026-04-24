package service.hq;

import java.util.List;
import java.util.Map;

import dto.hq.warehouse.WarehouseStockDetailDTO;
import dto.hq.warehouse.WarehouseStockListDTO;
import dto.hq.warehouse.WarehouseStockSearchDTO;

public interface WarehouseStockService {

	List<WarehouseStockListDTO> searchList(WarehouseStockSearchDTO searchDTO);
	Map<String, List<String>> getCategoryMaterialMap();
	WarehouseStockDetailDTO findStockDetailByStockNo(String stockNo);
}
