package dao.branch.stock;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.BranchStockDTO;
import util.MyBatisSqlSessionFactory;

public class BranchStockAlertDaoImpl implements BranchStockAlertDao {

	@Override
	public List<BranchStockDTO> selectExpiredStock(int branchCode) throws Exception {
		List<BranchStockDTO> expiredList = null;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			expiredList = sqlSession.selectList("mapper.branch.stock.alert.selectExpiredStock" , branchCode);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return expiredList;
	}

	@Override
	public List<BranchStockDTO> selectUrgentStock(int branchCode) throws Exception {
		List<BranchStockDTO> urgentList = null;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			urgentList = sqlSession.selectList("mapper.branch.stock.alert.selectUrgentStock" , branchCode);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return urgentList;
	}

	@Override
	public List<BranchStockDTO> selectWarningStock(int branchCode) throws Exception {
		List<BranchStockDTO> warningList = null;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			warningList = sqlSession.selectList("mapper.branch.stock.alert.selectWarningStock" , branchCode);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return warningList;
	}

	@Override
	public List<BranchStockDTO> selectEmptyStock(int branchCode) throws Exception {
		List<BranchStockDTO> emptyList = null;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			emptyList = sqlSession.selectList("mapper.branch.stock.alert.selectEmptyStock" , branchCode);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return emptyList;
	}
	
	@Override
	public List<BranchStockDTO> selectLackStock(int branchCode) throws Exception {
		List<BranchStockDTO> lackList = null;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			lackList = sqlSession.selectList("mapper.branch.stock.alert.selectLackStock" , branchCode);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return lackList;
	}


}
