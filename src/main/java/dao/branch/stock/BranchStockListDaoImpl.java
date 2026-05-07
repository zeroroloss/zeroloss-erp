package dao.branch.stock;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.BranchStockDTO;
import dto.MaterialDTO;
import dto.MaterialGroupDTO;
import util.MyBatisSqlSessionFactory;

public class BranchStockListDaoImpl implements BranchStockListDao {

	@Override
	public List<MaterialGroupDTO> selectCategoryList(Integer branchCode) throws Exception {
		List<MaterialGroupDTO> materialGroupList= null;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			materialGroupList = sqlSession.selectList("mapper.branch.stock.list.selectCategoryList", branchCode);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return materialGroupList;
	}

	@Override
	public List<MaterialDTO> selectMaterialListByCategory(Map<String, Object> params) throws Exception {
		List<MaterialDTO> materialList = null;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			materialList = sqlSession.selectList("mapper.branch.stock.list.selectMaterialListByCategory", params);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return materialList;
	}

	@Override
	public List<BranchStockDTO> selectBranchStockList(Map<String, Object> params) throws Exception {
		List<BranchStockDTO> branchStockList = null;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			branchStockList = sqlSession.selectList("mapper.branch.stock.list.selectBranchStockList", params);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return branchStockList;
	}

	@Override
	public int selectBranchStockCount(Map<String, Object> params) throws Exception {
		int StockCount = 0;
		try(SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			StockCount = sqlSession.selectOne("mapper.branch.stock.list.selectBranchStockCount", params);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return StockCount;
	}

}
