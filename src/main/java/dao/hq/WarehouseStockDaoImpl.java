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

public class WarehouseStockDaoImpl implements WarehouseStockDao {

	@Override
	public List<WarehouseStockListDTO> findStockList(SqlSession sqlSession, WarehouseStockSearchDTO searchDTO) {
		return sqlSession.selectList("mapper.hq.warehouseStock.selectStockList", searchDTO);
	}

	@Override
	public List<CategoryMaterialDTO> findAllCategoryMaterials(SqlSession sqlSession) {
		return sqlSession.selectList("mapper.hq.warehouseStock.selectCategoryMaterials");
	}

	@Override
	public WarehouseStockDetailDTO findStockDetailByStockNo(SqlSession sqlSession, String stockNo) {
		// {stockNo}재고의 기본 정보 조회
		// 	재고 변동 리스트는 Service에서 findMovementsByStockNo로 넣어줌!
		return sqlSession.selectOne("mapper.hq.warehouseStock.selectDetail", stockNo);
	}

	@Override
	public List<WarehouseStockMovementDTO> findMovementsByStockNo(SqlSession sqlSession, String stockNo) {
		// {stockNo}의 재고 변동 리스트 조회
		return sqlSession.selectList("mapper.hq.warehouseStock.selectMovementsByStockNo", stockNo);
	}
	

	@Override
	public List<String> findAllSuppliers(SqlSession sqlSession) {
		return sqlSession.selectList("mapper.hq.warehouseStock.findAllSuppliers");
	}
	
	@Override
	public List<InboundRecordDTO> findInboundRecords(SqlSession ss, Map<String, Object> params) {
	    return ss.selectList("HqWarehouseMapper.findInboundRecords", params);
	}

	@Override
	public int insertInbound(SqlSession ss, Map<String, Object> params) {
	    return ss.insert("HqWarehouseMapper.insertInbound", params);
	}
}

