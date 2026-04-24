package dao.hq;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.hq.warehouse.CategoryMaterialDTO;
import dto.hq.warehouse.WarehouseStockDetailDTO;
import dto.hq.warehouse.WarehouseStockListDTO;
import dto.hq.warehouse.WarehouseStockMovementDTO;
import dto.hq.warehouse.WarehouseStockSearchDTO;


public interface WarehouseStockDao {
	List<WarehouseStockListDTO> findStockList(SqlSession sqlSession, WarehouseStockSearchDTO searchDTO);
	List<CategoryMaterialDTO> findAllCategoryMaterials(SqlSession sqlSession);
	WarehouseStockDetailDTO findStockDetailByStockNo(SqlSession sqlSession, String stockNo);
	List<WarehouseStockMovementDTO> findMovementsByStockNo(SqlSession sqlSession, String stockNo);
}
