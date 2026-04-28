package dao.branch.sales;

import dto.RankDTO;
import org.apache.ibatis.session.SqlSession;

import java.util.List;
import java.util.Map;

public class BranchSalesRankDAO {

    public List<RankDTO> selectRankList(SqlSession sqlSession, Map<String, Object> params) {
        return sqlSession.selectList("BranchSalesRankMapper.selectRankList", params);
    }
}
