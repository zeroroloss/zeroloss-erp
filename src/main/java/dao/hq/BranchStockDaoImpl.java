package dao.hq;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.hq.branch_stock.BranchDTO;
import dto.hq.branch_stock.BranchStockListDTO;
import dto.hq.branch_stock.BranchStockSearchDTO;
import dto.hq.branch_stock.MaterialDTO;
import dto.hq.branch_stock.MaterialGroupDTO;

public class BranchStockDaoImpl implements BranchStockDao {

	@Override
	public List<BranchStockListDTO> findStockList(SqlSession sqlSession, BranchStockSearchDTO searchDTO) {
		return sqlSession.selectList("mapper.hq.branchstock.selectStockList", searchDTO);
	}
	
	@Override
	public List<BranchDTO> findBranchList(SqlSession sqlSession) {
		return sqlSession.selectList("mapper.hq.branchstock.selectBranchList");
	}

	@Override
	public List<MaterialGroupDTO> findMaterialGroupList(SqlSession sqlSession) {
		return sqlSession.selectList("mapper.hq.branchstock.selectMaterialGroupList");
	}

	@Override
	public List<MaterialDTO> selectMaterialByCategory(SqlSession sqlSession, int materialGroupId) {
		return sqlSession.selectList("mapper.hq.branchstock.selectMaterialByCategory", materialGroupId);
	}

}
