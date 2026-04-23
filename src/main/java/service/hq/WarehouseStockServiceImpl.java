package service.hq;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import dao.hq.WarehouseStockDao;
import dao.hq.WarehouseStockDaoImpl;
import dto.hq.warehouse.CategoryMaterialDTO;
import dto.hq.warehouse.WarehouseStockResultDTO;
import dto.hq.warehouse.WarehouseStockSearchDTO;

public class WarehouseStockServiceImpl implements WarehouseStockService {

	private WarehouseStockDao dao;

	public WarehouseStockServiceImpl() {
		dao = new WarehouseStockDaoImpl();
	}

	@Override
	public List<WarehouseStockResultDTO> searchList(WarehouseStockSearchDTO searchDTO) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return dao.searchList(sqlSession, searchDTO);
		}
	}

	@Override
	public Map<String, List<String>> getCategoryMaterialMap() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			List<CategoryMaterialDTO> list = dao.selectCategoryMaterials(sqlSession);
			
			Map<String, List<String>> map = new LinkedHashMap<>();
			for (CategoryMaterialDTO dto : list) {
				map.computeIfAbsent(dto.getGroupName(), k -> new ArrayList<>())
					.add(dto.getMaterialName());
			}
			
			return map;
		}
	}
}
