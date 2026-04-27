//package service.hq;
//
//import java.util.List;
//import java.util.Map;
//
//import dto.hq.warehouse.ExpiryItemDTO;
//import dto.hq.warehouse.ExpirySearchDTO;
//import dto.hq.warehouse.InboundRecordDTO;
//import dto.hq.warehouse.InboundRequestDTO;
//import dto.hq.warehouse.InboundSearchDTO;
//import dto.hq.warehouse.WarehouseStockDetailDTO;
//import dto.hq.warehouse.WarehouseStockListDTO;
//import dto.hq.warehouse.WarehouseStockSearchDTO;
//
//public interface WarehouseStockService {
//
//	List<WarehouseStockListDTO> searchList(WarehouseStockSearchDTO searchDTO);
//	Map<String, List<String>> getCategoryMaterialMap();
//	WarehouseStockDetailDTO findStockDetailByStockNo(String stockNo);
//	List<String> findSupplierNames();
//	
//	// 입고
//	List<InboundRecordDTO> findInboundRecords(InboundSearchDTO searchDTO);
//	Map<String, Integer> getMaterialPriceMap();
//	boolean processInbound(InboundRequestDTO dto);
//	
//	// 유통기한 조회
//	List<ExpiryItemDTO> findExpiryItems(ExpirySearchDTO searchDTO);
//	boolean processDisposal(List<String> stockNos);
//}
