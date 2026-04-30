package dao.branch.stock;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.BranchStockChangeHistoryDTO;
import dto.BranchStockDisposalHistoryDTO;
import util.MyBatisSqlSessionFactory;

public class BranchStockHistoryDaoImpl implements BranchStockHistoryDao {

	@Override
	public List<BranchStockChangeHistoryDTO> selectStockChangeHistory(Map<String, Object> params) throws Exception {
		List<BranchStockChangeHistoryDTO> stockChangeHistory = null; 
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			stockChangeHistory = sqlSession.selectList("mapper.branch.stock.history.selectStockChangeHistory", params);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return stockChangeHistory;
	}

	@Override
	public int selectStockChangeHistoryCount(Map<String, Object> params) throws Exception {
		int stockChangeCount = 0;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			stockChangeCount = sqlSession.selectOne("mapper.branch.stock.history.selectStockChangeHistoryCount", params);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return stockChangeCount;
	}

	@Override
	public List<BranchStockDisposalHistoryDTO> selectDisposalHistory(Map<String, Object> params) throws Exception {
		List<BranchStockDisposalHistoryDTO> disposalHistory = null;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			disposalHistory = sqlSession.selectList("mapper.branch.stock.history.selectDisposalHistory", params);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return disposalHistory;
	}

	@Override
	public int selectDisposalHistoryCount(Map<String, Object> params) throws Exception {
		int disposalCount = 0;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			disposalCount = sqlSession.selectOne("mapper.branch.stock.history.selectDisposalHistoryCount", params);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return disposalCount;
	}

}
