package dao.branch.stock;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.branch.stock.BranchSafetyStockRowDTO;

public interface SatefyStockDao {

	List<BranchSafetyStockRowDTO> selectList(SqlSession sqlSession, Map<String, Object> param);
	int insert(SqlSession sqlSession, Map<String, Object> param);

}
