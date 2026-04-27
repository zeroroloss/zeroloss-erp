//package dao.hq;
//
//import java.util.HashMap;
//import java.util.LinkedHashMap;
//import java.util.List;
//import java.util.Map;
//import java.util.UUID;
//
//import org.apache.ibatis.session.SqlSession;
//
//import dto.hq.warehouse.CategoryMaterialDTO;
//import dto.hq.warehouse.ExpiryItemDTO;
//import dto.hq.warehouse.ExpirySearchDTO;
//import dto.hq.warehouse.InboundRecordDTO;
//import dto.hq.warehouse.InboundRequestDTO;
//import dto.hq.warehouse.InboundSearchDTO;
//import dto.hq.warehouse.WarehouseStockDetailDTO;
//import dto.hq.warehouse.WarehouseStockListDTO;
//import dto.hq.warehouse.WarehouseStockMovementDTO;
//import dto.hq.warehouse.WarehouseStockSearchDTO;
//
//public class WarehouseStockDaoImpl implements WarehouseStockDao {
//
//	@Override
//	public List<WarehouseStockListDTO> findStockList(SqlSession sqlSession, WarehouseStockSearchDTO searchDTO) {
//		return sqlSession.selectList("mapper.hq.warehouseStock.selectStockList", searchDTO);
//	}
//
//	@Override
//	public List<CategoryMaterialDTO> findAllCategoryMaterials(SqlSession sqlSession) {
//		return sqlSession.selectList("mapper.hq.warehouseStock.selectCategoryMaterials");
//	}
//
//	@Override
//	public WarehouseStockDetailDTO findStockDetailByStockNo(SqlSession sqlSession, String stockNo) {
//		// {stockNo}재고의 기본 정보 조회
//		// 	재고 변동 리스트는 Service에서 findMovementsByStockNo로 넣어줌!
//		return sqlSession.selectOne("mapper.hq.warehouseStock.selectDetail", stockNo);
//	}
//
//	@Override
//	public List<WarehouseStockMovementDTO> findMovementsByStockNo(SqlSession sqlSession, String stockNo) {
//		// {stockNo}의 재고 변동 리스트 조회
//		return sqlSession.selectList("mapper.hq.warehouseStock.selectMovementsByStockNo", stockNo);
//	}
//	
//
//	@Override
//	public List<String> findAllSuppliers(SqlSession sqlSession) {
//		return sqlSession.selectList("mapper.hq.warehouseStock.findAllSuppliers");
//	}
//	
//	@Override
//	public List<InboundRecordDTO> findInboundRecords(SqlSession sqlSession, InboundSearchDTO searchDTO) {
//	    return sqlSession.selectList("mapper.hq.warehouseStock.findInboundRecords", searchDTO);
//	}
//
//	@Override
//	public int insertInbound(SqlSession sqlSession, InboundRequestDTO inboundReqDTO) {
//	    return sqlSession.insert("mapper.hq.warehouseStock.insertInbound", inboundReqDTO);
//	}
//
//	@Override
//	public Map<String, Integer> getMaterialPriceMap(SqlSession sqlSession) {
//	    List<Map<String, Object>> list = sqlSession.selectList("mapper.hq.warehouseStock.selectMaterialPriceMap");
//
//	    Map<String, Integer> resultMap = new LinkedHashMap<>();
//
//	    for (Map<String, Object> row : list) {
//	        String name = (String) row.get("materialName");
//	        Integer price = ((Number) row.get("materialPrice")).intValue();
//	        resultMap.put(name, price);
//	    }
//
//	    return resultMap;
//	}
//	
//	@Override
//	public String insertWarehouseStock(SqlSession session, InboundRequestDTO dto, int inboundId) {
//
//		String stockNo = "STK-" + String.format("%04d", inboundId);
//		
//	    Map<String, Object> param = new HashMap<>();
//	    param.put("stockNo", stockNo);
//	    param.put("itemName", dto.getItemName());
//	    param.put("quantity", dto.getQuantity());
//	    param.put("expiryDate", dto.getExpiryDate());
//	    param.put("inboundId", inboundId);
//
//	    int rows = session.insert(
//	        "mapper.hq.warehouseStock.insertWarehouseStock",
//	        param
//	    );
//	    
//	    return rows > 0 ? stockNo : null;
//	}
//	
//	@Override
//	public int insertStockHistory(SqlSession session, String stockNo, InboundRequestDTO dto) {
//
//	    Map<String, Object> param = new HashMap<>();
//	    param.put("stockNo", stockNo);
//	    param.put("quantity", dto.getQuantity());
//
//	    return session.insert("mapper.hq.warehouseStock.insertStockHistory", param);
//	}
//
//	@Override
//	public List<ExpiryItemDTO> findExpiryItems(SqlSession sqlSession, ExpirySearchDTO searchDTO) {
//		return sqlSession.selectList("mapper.hq.warehouseStock.selectExpiryItems", searchDTO);
//	}
//
//	@Override
//	public int updateStockStatusToDisposed(SqlSession sqlSession, String stockNo) {
//		Map<String, Object> param = new HashMap<>();
//		param.put("stockNo", stockNo);
//		param.put("status", "DISPOSED");
//		return sqlSession.update("mapper.hq.warehouseStock.updateStockStatus", param);
//	}
//
//	@Override
//	public int insertDisposalHistory(SqlSession sqlSession, String stockNo) {
//		Map<String, Object> param = new HashMap<>();
//		param.put("stockNo", stockNo);
//		param.put("changeType", "DISPOSAL");
//		return sqlSession.insert("mapper.hq.warehouseStock.insertDisposalHistory", param);
//	}
//}
//
