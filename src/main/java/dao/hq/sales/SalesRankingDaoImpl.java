package dao.hq.sales;

import dto.hq.sales.SalesRankingDto;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SalesRankingDaoImpl implements SalesRankingDao {

    private SqlSessionFactory sqlSessionFactory;

    public SalesRankingDaoImpl() {
        sqlSessionFactory = MyBatisSqlSessionFactory.getSqlSessionFactory();
    }

    @Override
    public List<SalesRankingDto> getSalesRanking(String startDate, String endDate) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            // 🟢 파라미터를 Map에 담아 전달
            Map<String, String> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            return session.selectList("mapper.hq.sales.SalesRankingMapper.getSalesRanking", params);
        }
    }

    @Override
    public List<SalesRankingDto> getSalesQuantityRanking(String startDate, String endDate) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            // 🟢 파라미터를 Map에 담아 전달
            Map<String, String> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            return session.selectList("mapper.hq.sales.SalesRankingMapper.getSalesQuantityRanking", params);
        }
    }
}