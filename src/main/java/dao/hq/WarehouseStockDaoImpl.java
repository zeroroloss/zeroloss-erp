package dao.hq;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.hq.warehouse.CategoryMaterialDTO;
import dto.hq.warehouse.WarehouseStockResultDTO;
import dto.hq.warehouse.WarehouseStockSearchDTO;

public class WarehouseStockDaoImpl implements WarehouseStockDao {

	@Override
	public List<WarehouseStockResultDTO> searchList(SqlSession sqlSession, WarehouseStockSearchDTO searchDTO) {
		return sqlSession.selectList("mapper.hq.warehouseStock.selectStocks", searchDTO);
	}

	@Override
	public List<CategoryMaterialDTO> selectCategoryMaterials(SqlSession sqlSession) {
		return sqlSession.selectList("mapper.hq.warehouseStock.selectCategoryMaterials");
	}
}

