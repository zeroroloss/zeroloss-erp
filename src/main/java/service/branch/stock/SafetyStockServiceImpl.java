package service.branch.stock;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.branch.stock.SafetyStockDaoImpl;
import dao.branch.stock.SatefyStockDao;
import dto.branch.stock.BranchSafetyStockRowDTO;
import util.MyBatisSqlSessionFactory;

public class SafetyStockServiceImpl implements SafetyStockService {
	
	private final SatefyStockDao dao = new SafetyStockDaoImpl();

	@Override
	public List<BranchSafetyStockRowDTO> selectSafetyStocks(int branchCode, String categoryName, String itemName) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			Map<String, Object> param = new HashMap<>();
			param.put("branchCode", branchCode);
			param.put("categoryName", categoryName);
			param.put("itemName", itemName);
			
			return dao.selectList(sqlSession, param);
			
		}
	}

	@Override
	public int updateSafetyStock(int branchCode, String materialCode, java.math.BigDecimal safeStockQty) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			Map<String, Object> param = new HashMap<>();
			param.put("branchCode", branchCode);
			param.put("materialCode", materialCode);
			param.put("safeStockQty", safeStockQty);
			
			// UPSERT
			int updated = dao.insert(sqlSession, param);
			if (updated > 0) {
				sqlSession.commit();
			}
			return updated;
		}
	}
}
