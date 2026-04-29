package dao.hq.sales;

import dto.BranchDTO;
import dto.branch.sales.DailySalesDTO;
import dto.branch.sales.HourlySalesDTO;
import dto.branch.sales.MenuSalesDTO;
import dto.hq.sales.*;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.MyBatisSqlSessionFactory;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class HqSalesDAOImpl implements HqSalesDAO {

    private final SqlSessionFactory sqlSessionFactory = MyBatisSqlSessionFactory.getSqlSessionFactory();

    @Override
    public List<BranchDTO> selectActiveBranches() {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            return sqlSession.selectList("mapper.hq.sales.HqSalesMapper.selectActiveBranches");
        }
    }

    @Override
    public List<DailySalesDTO> getDailySales(String branchCode, LocalDate startDate, LocalDate endDate) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("branchCode", branchCode);
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            return sqlSession.selectList("mapper.hq.sales.HqSalesMapper.getDailySales", params);
        }
    }

    @Override
    public List<HourlySalesDTO> getHourlySales(String branchCode, LocalDate targetDate) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("branchCode", branchCode);
            params.put("targetDate", targetDate);
            return sqlSession.selectList("mapper.hq.sales.HqSalesMapper.getHourlySales", params);
        }
    }

    @Override
    public List<MenuSalesDTO> getMenuSales(String branchCode, LocalDate targetDate, Integer categoryId, String subCategoryCode) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("branchCode", branchCode);
            params.put("targetDate", targetDate);
            params.put("categoryId", categoryId);
            params.put("subCategoryCode", subCategoryCode);
            return sqlSession.selectList("mapper.hq.sales.HqSalesMapper.getMenuSales", params);
        }
    }

    @Override
    public HqSalesSummaryDTO getHeadquartersSalesSummary(LocalDate targetDate) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("targetDate", targetDate);
            return sqlSession.selectOne("mapper.hq.sales.HqSalesMapper.getHeadquartersSalesSummary", params);
        }
    }

    @Override
    public HqTodaySalesSummaryDTO getTodaySalesSummary(LocalDate targetDate) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("targetDate", targetDate);
            return sqlSession.selectOne("mapper.hq.sales.HqSalesMapper.getTodaySalesSummary", params);
        }
    }

    @Override
    public List<CategoryDTO> getAllMainCategories() {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            return sqlSession.selectList("mapper.hq.sales.HqSalesMapper.getAllMainCategories");
        }
    }

    @Override
    public List<SubCategoryDTO> getSubCategoriesByMainCategory(int mainCategoryId) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            return sqlSession.selectList("mapper.hq.sales.HqSalesMapper.getSubCategoriesByMainCategory", mainCategoryId);
        }
    }

    @Override
    public List<MenuSalesDTO> getMenusByCategory(int categoryId) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("categoryId", categoryId);
            return sqlSession.selectList("mapper.hq.sales.HqSalesMapper.getMenusByCategory", params);
        }
    }

    @Override
    public List<MenuSalesRankDTO> getMenuSalesRanksByCategory(LocalDate targetDate, int categoryId) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("targetDate", targetDate);
            params.put("categoryId", categoryId);
            return sqlSession.selectList("mapper.hq.sales.HqSalesMapper.getMenuSalesRanksByCategory", params);
        }
    }

    @Override
    public List<BranchMenuSalesRankDTO> getBranchSalesRanksByMenu(LocalDate startDate, LocalDate endDate, String recipeCode) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("recipeCode", recipeCode);
            return sqlSession.selectList("mapper.hq.sales.HqSalesMapper.getBranchSalesRanksByMenu", params);
        }
    }
}
