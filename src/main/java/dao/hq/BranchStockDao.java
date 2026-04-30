package dao.hq;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.hq.branch_stock.BranchDTO;
import dto.hq.branch_stock.BranchStockListDTO;
import dto.hq.branch_stock.BranchStockSearchDTO;
import dto.hq.branch_stock.MaterialDTO;
import dto.hq.branch_stock.MaterialGroupDTO;

public interface BranchStockDao {
	List<BranchStockListDTO> findStockList(SqlSession sqlSession, BranchStockSearchDTO searchDTO);
	List<BranchDTO> findBranchList(SqlSession sqlSession);
	List<MaterialGroupDTO> findMaterialGroupList(SqlSession sqlSession);
	List<MaterialDTO> selectMaterialByCategory(SqlSession sqlSession, int materialGroupId);
}
