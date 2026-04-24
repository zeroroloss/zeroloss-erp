package dao.hq;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.hq.warehouse.CategoryMaterialDTO;
import dto.hq.warehouse.InboundRecordDTO;
import dto.hq.warehouse.WarehouseStockDetailDTO;
import dto.hq.warehouse.WarehouseStockListDTO;
import dto.hq.warehouse.WarehouseStockMovementDTO;
import dto.hq.warehouse.WarehouseStockSearchDTO;


public interface WarehouseStockDao {
	List<WarehouseStockListDTO> findStockList(SqlSession sqlSession, WarehouseStockSearchDTO searchDTO);
	List<CategoryMaterialDTO> findAllCategoryMaterials(SqlSession sqlSession);
	WarehouseStockDetailDTO findStockDetailByStockNo(SqlSession sqlSession, String stockNo);
	List<WarehouseStockMovementDTO> findMovementsByStockNo(SqlSession sqlSession, String stockNo);
	
	// 입고
	List<String> findAllSuppliers(SqlSession sqlSession);
	int insertInbound(SqlSession ss, Map<String, Object> params);
	List<InboundRecordDTO> findInboundRecords(SqlSession ss, Map<String, Object> params);
}
