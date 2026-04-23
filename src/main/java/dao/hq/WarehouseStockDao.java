package dao.hq;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.hq.warehouse.CategoryMaterialDTO;
import dto.hq.warehouse.WarehouseStockResultDTO;
import dto.hq.warehouse.WarehouseStockSearchDTO;


public interface WarehouseStockDao {
	List<WarehouseStockResultDTO> searchList(SqlSession sqlSession, WarehouseStockSearchDTO searchDTO);
	List<CategoryMaterialDTO> selectCategoryMaterials(SqlSession sqlSession);
}
