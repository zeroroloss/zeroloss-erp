package dao.branch.sales;

import dto.RankDTO;
import org.apache.ibatis.session.SqlSession;

import java.util.List;
import java.util.Map;

public interface BranchSalesRankDAO {
    List<RankDTO> selectRankList(SqlSession sqlSession, Map<String, Object> params);
}
