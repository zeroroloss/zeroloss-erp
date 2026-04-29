package dao.branch.stock;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.branch.stock.BranchSafetyStockRowDTO;

public class SafetyStockDaoImpl implements SatefyStockDao {

	@Override
	public List<BranchSafetyStockRowDTO> selectList(SqlSession sqlSession, Map<String, Object> param) {
		return sqlSession.selectList("mapper.branch.stock.BranchSafetyStockMapper.selectSafetyStocks", param);
	}

	@Override
	public int insert(SqlSession sqlSession, Map<String, Object> param) {
		return sqlSession.insert("mapper.branch.stock.BranchSafetyStockMapper.insertSafetyStock", param);
	}
}
