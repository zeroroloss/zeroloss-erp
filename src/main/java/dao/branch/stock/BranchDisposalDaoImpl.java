package dao.branch.stock;

import java.math.BigDecimal;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.BranchStockChangeHistoryDTO;
import dto.BranchStockDisposalHistoryDTO;
import util.MyBatisSqlSessionFactory;

public class BranchDisposalDaoImpl implements BranchDisposalDao {

	@Override
	public BigDecimal selectCurrentQty(String branchStockCode) throws Exception {
		BigDecimal selectCurrentQty = null;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			selectCurrentQty = sqlSession.selectOne("mapper.branch.stock.history.selectCurrentQty",branchStockCode);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return selectCurrentQty;
	}

	@Override
	public void insertStockChangeHistory(BranchStockChangeHistoryDTO dto) throws Exception {
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			sqlSession.insert("mapper.branch.stock.history.insertStockChangeHistory", dto);
			sqlSession.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void insertDisposalHistory(BranchStockDisposalHistoryDTO dto) throws Exception {
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			sqlSession.insert("mapper.branch.stock.history.insertDisposalHistory", dto);
			sqlSession.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public int updateBranchStockQty(Map<String, Object> params) throws Exception {
		int updateBranchStockQty = 0;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			updateBranchStockQty =  sqlSession.insert("mapper.branch.stock.history.updateBranchStockQty", params);
			sqlSession.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return updateBranchStockQty;
	}

}
