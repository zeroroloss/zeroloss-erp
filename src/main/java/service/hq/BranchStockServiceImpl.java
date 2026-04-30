package service.hq;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dao.hq.BranchStockDao;
import dao.hq.BranchStockDaoImpl;
import dto.hq.branch_stock.BranchDTO;
import dto.hq.branch_stock.BranchStockListDTO;
import dto.hq.branch_stock.BranchStockSearchDTO;
import dto.hq.branch_stock.MaterialDTO;
import dto.hq.branch_stock.MaterialGroupDTO;
import util.MyBatisSqlSessionFactory;

public class BranchStockServiceImpl implements BranchStockService {
	
	private BranchStockDao branchStockDao = new BranchStockDaoImpl();
	
	@Override
	public List<BranchStockListDTO> findStockList(BranchStockSearchDTO searchDTO) {

		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return branchStockDao.findStockList(sqlSession, searchDTO);
		}
	}
	
	@Override
	public List<BranchDTO> findBranchList() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return branchStockDao.findBranchList(sqlSession);
		}
	}

	@Override
	public List<MaterialGroupDTO> findMaterialGroupList() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return branchStockDao.findMaterialGroupList(sqlSession);
		}
	}

	@Override
	public List<MaterialDTO> findMaterialByCategory(int materialGroupId) {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return branchStockDao.selectMaterialByCategory(sqlSession, materialGroupId);
		}
	}

}
