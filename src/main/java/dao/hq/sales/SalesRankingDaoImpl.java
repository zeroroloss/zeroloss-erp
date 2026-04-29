package dao.hq.sales;

import dto.hq.sales.DailySalesTrendDto;
import dto.hq.sales.HourlySalesTrendDto;
import dto.hq.sales.MenuCategoryDto;
import dto.hq.sales.MenuDto;
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
            Map<String, String> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            return session.selectList("mapper.hq.sales.SalesRankingMapper.getSalesRanking", params);
        }
    }

    @Override
    public List<SalesRankingDto> getSalesQuantityRanking(String startDate, String endDate) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            Map<String, String> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            return session.selectList("mapper.hq.sales.SalesRankingMapper.getSalesQuantityRanking", params);
        }
    }

    @Override
    public List<SalesRankingDto> getMenuSalesRanking(String startDate, String endDate) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            Map<String, String> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            return session.selectList("mapper.hq.sales.SalesRankingMapper.getMenuSalesRanking", params);
        }
    }

    @Override
    public List<SalesRankingDto> getMenuQuantityRanking(String startDate, String endDate) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            Map<String, String> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            return session.selectList("mapper.hq.sales.SalesRankingMapper.getMenuQuantityRanking", params);
        }
    }

    @Override
    public List<SalesRankingDto> getSpecificMenuSalesRanking(String startDate, String endDate, String recipeCode) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            Map<String, String> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("recipeCode", recipeCode);
            return session.selectList("mapper.hq.sales.SalesRankingMapper.getSpecificMenuSalesRanking", params);
        }
    }

    @Override
    public List<SalesRankingDto> getSpecificMenuQuantityRanking(String startDate, String endDate, String recipeCode) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            Map<String, String> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("recipeCode", recipeCode);
            return session.selectList("mapper.hq.sales.SalesRankingMapper.getSpecificMenuQuantityRanking", params);
        }
    }

    @Override
    public List<MenuCategoryDto> getAllMenuCategories() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.hq.sales.SalesRankingMapper.getAllMenuCategories");
        }
    }

    @Override
    public List<MenuDto> getMenusByCategory(int categoryCode) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.hq.sales.SalesRankingMapper.getMenusByCategory", categoryCode);
        }
    }

    @Override
    public List<HourlySalesTrendDto> getHourlySalesTrend(String startDate, String endDate) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            Map<String, String> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            return session.selectList("mapper.hq.sales.SalesRankingMapper.getHourlySalesTrend", params);
        }
    }

    @Override
    public List<DailySalesTrendDto> getDailySalesTrend(String startDate, String endDate) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            Map<String, String> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            return session.selectList("mapper.hq.sales.SalesRankingMapper.getDailySalesTrend", params);
        }
    }
}
