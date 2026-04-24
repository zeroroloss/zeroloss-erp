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
	public List<InboundRecordDTO> getInboundRecords(
	        String supplierName, String category,
	        String itemName, String startDate, String endDate) {

	    try (SqlSession ss = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
	        Map<String, Object> params = new HashMap<>();
	        params.put("supplierName", supplierName);
	        params.put("category",     category);
	        params.put("itemName",     itemName);
	        params.put("startDate",    startDate);
	        params.put("endDate",      endDate);
	        return dao.findInboundRecords(ss, params);
	    }
	}

	@Override
	public boolean registerInbound(InboundRequestDTO dto, int empId) {
	    try (SqlSession ss = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
	        Map<String, Object> params = new HashMap<>();
	        params.put("supplier",   dto.getSupplier());
	        params.put("itemName",   dto.getItemName());
	        params.put("quantity",   dto.getQuantity());
	        params.put("unitPrice",  dto.getUnitPrice());
	        params.put("expiryDate", dto.getExpiryDate());
	        params.put("empId",      empId);

	        int rows = dao.insertInbound(ss, params);
	        if (rows > 0) {
	            ss.commit();
	            return true;
	        }
	        return false;
	    }
	}

}
