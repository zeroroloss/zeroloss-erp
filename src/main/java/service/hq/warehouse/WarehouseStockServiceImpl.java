package service.hq.warehouse;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import dao.hq.WarehouseStockDao;
import dao.hq.WarehouseStockDaoImpl;
import dto.hq.warehouse.CategoryMaterialDTO;
import dto.hq.warehouse.ExpiryItemDTO;
import dto.hq.warehouse.ExpirySearchDTO;
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

	        int inboundId = dto.getHqInboundId();
	        System.out.println("inboundId = " + inboundId);
	    	
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

	@Override
	public List<ExpiryItemDTO> findExpiryItems(ExpirySearchDTO searchDTO) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			List<ExpiryItemDTO> items = dao.findExpiryItems(sqlSession, searchDTO);
			return items != null ? items : new ArrayList<>();
		} catch (Exception e) {
			e.printStackTrace();
			return new ArrayList<>();
		}
	}

	@Override
	public boolean processDisposal(List<String> stockNos) {
		// false -> auto commit X
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false)) {
			
			// 폐기할 각 재고에 대해 처리
			for (String stockNo : stockNos) {
				// 1. warehouse_stock 상태 업데이트 (DISPOSED)
				int updateRows = dao.updateStockStatusToDisposed(sqlSession, stockNo);
				if (updateRows == 0) {
					sqlSession.rollback();
					return false;
				}
				
				// 2. warehouse_stock_change_history 기록 (DISPOSAL)
				int historyRows = dao.insertDisposalHistory(sqlSession, stockNo);
				if (historyRows == 0) {
					sqlSession.rollback();
					return false;
				}
			}
			
			sqlSession.commit();
			return true;
			
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}