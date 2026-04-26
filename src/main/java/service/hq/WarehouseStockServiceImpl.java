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
	public boolean processInbound(InboundRequestDTO dto) {
		// false -> auto commit X
	    try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false)) {
	        
	    	// 1. 입고 이력 + PK 자동 세팅
	    	int inboundRows = dao.insertInbound(sqlSession, dto);

	        if (inboundRows == 0) {
	            sqlSession.rollback();
	            return false;
	        }

	        Integer inboundId = dto.getHqInboundId();
	        System.out.println("inboundId = " + inboundId);
	        if (inboundId == null) {
	            sqlSession.rollback();
	            throw new RuntimeException("inboundId 생성 실패");
	        }
	    	
	        // 2. 재고 등록 + stockNo 즉시 반환
	        String stockNo = dao.insertWarehouseStock(sqlSession, dto, inboundId);

	        if (stockNo == null) {
	            sqlSession.rollback();
	            return false;
	        }
	        
	        // 3. 재고 이력
	        int historyRows = dao.insertStockHistory(sqlSession, stockNo, dto);

	        if (historyRows == 0) {
	            sqlSession.rollback();
	            return false;
	        }

	        sqlSession.commit();
	        return true;
	    	
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}


}