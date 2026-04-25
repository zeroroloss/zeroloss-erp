package service.hq;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import dao.hq.WarehouseStockDao;
import dao.hq.WarehouseStockDaoImpl;
import dto.hq.SupplierDTO;
import dto.hq.warehouse.CategoryMaterialDTO;
import dto.hq.warehouse.InboundRecordDTO;
import dto.hq.warehouse.InboundRequestDTO;
import dto.hq.warehouse.InboundSearchDTO;
import dto.hq.warehouse.WarehouseStockDetailDTO;
import dto.hq.warehouse.WarehouseStockListDTO;
import dto.hq.warehouse.WarehouseStockMovementDTO;
import dto.hq.warehouse.WarehouseStockSearchDTO;

public class WarehouseStockServiceImpl implements WarehouseStockService {

	private WarehouseStockDao dao;

	public WarehouseStockServiceImpl() {
		dao = new WarehouseStockDaoImpl();
	}

	@Override
	public List<WarehouseStockListDTO> searchList(WarehouseStockSearchDTO searchDTO) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return dao.findStockList(sqlSession, searchDTO);
		}
	}

	@Override
	public Map<String, List<String>> getCategoryMaterialMap() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			List<CategoryMaterialDTO> list = dao.findAllCategoryMaterials(sqlSession);
			
			Map<String, List<String>> map = new LinkedHashMap<>();
			for (CategoryMaterialDTO dto : list)
				map.computeIfAbsent(dto.getGroupName(), k -> new ArrayList<>())
					.add(dto.getMaterialName());
			return map;
		}
	}

	@Override
	public WarehouseStockDetailDTO findStockDetailByStockNo(String stockNo) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			// 재고의 정보 + 재고 변동 리스트
			WarehouseStockDetailDTO detail = dao.findStockDetailByStockNo(sqlSession, stockNo);
			List<WarehouseStockMovementDTO> movements = dao.findMovementsByStockNo(sqlSession, stockNo);
			System.out.println(movements);
			detail.setMovements(
				Optional.ofNullable(movements).orElseGet(ArrayList::new)
			);
			return detail;
		}
	}

	@Override
	public List<String> findSupplierNames() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return dao.findAllSuppliers(sqlSession); 
		}
	}
	
	@Override
	public List<InboundRecordDTO> findInboundRecords(InboundSearchDTO searchDTO) {
	    try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
	        return dao.findInboundRecords(sqlSession, searchDTO);
	    }
	}

	@Override
	public Map<String, Integer> getMaterialPriceMap() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
	        return dao.getMaterialPriceMap(sqlSession);
	    }
	}
	@Override
	public boolean registerInbound(InboundRequestDTO dto) {
	    try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
	        int rows = dao.insertInbound(sqlSession, dto);
	        if (rows > 0) {
	        	sqlSession.commit();
	            return true;
	        }
	        return false;
	    }
	}


}