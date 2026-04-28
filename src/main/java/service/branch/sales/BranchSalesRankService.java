package service.branch.sales;

import dao.branch.sales.BranchSalesRankDAO;
import dto.RankDTO;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.MyBatisSqlSessionFactory;

import java.util.List;
import java.util.Map;

public class BranchSalesRankService {

    private final BranchSalesRankDAO salesRankDAO = new BranchSalesRankDAO();
    private final SqlSessionFactory sqlSessionFactory = MyBatisSqlSessionFactory.getSqlSessionFactory();

    public List<RankDTO> getTop10(String branchCode, String rankType, String sort, String startDate, String endDate) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = buildParams(branchCode, rankType, sort, startDate, endDate, "DESC");
            return salesRankDAO.selectRankList(sqlSession, params);
        }
    }

    public List<RankDTO> getWorst10(String branchCode, String rankType, String sort, String startDate, String endDate) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = buildParams(branchCode, rankType, sort, startDate, endDate, "ASC");
            return salesRankDAO.selectRankList(sqlSession, params);
        }
    }

    private Map<String, Object> buildParams(String branchCode, String rankType, String sort, String startDate, String endDate, String order) {
        return Map.of(
                "branchCode", branchCode,
                "rankType", rankType,
                "sort", sort,
                "startDate", startDate,
                "endDate", endDate,
                "order", order
        );
    }
}
