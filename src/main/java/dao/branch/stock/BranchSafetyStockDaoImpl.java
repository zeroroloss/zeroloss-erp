package dao.branch.stock;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.branch.stock.BranchSafetyStockRowDTO;
import util.MyBatisSqlSessionFactory;

public class BranchSafetyStockDaoImpl implements BranchSafetyStockDao {
	@Override
	public List<BranchSafetyStockRowDTO> selectSafetyStocks(int branchCode, String categoryName, String itemName) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			Map<String, Object> param = new HashMap<>();
			param.put("branchCode", branchCode);
			param.put("categoryName", categoryName);
			param.put("itemName", itemName);
			
			return sqlSession.selectList("mapper.branch.stock.BranchSafetyStockMapper.selectSafetyStocks", param);
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
			int updated = sqlSession.insert("mapper.branch.stock.BranchSafetyStockMapper.insertSafetyStock", param);
			if (updated > 0) {
				sqlSession.commit();
			}
			return updated;
		}
	}
}