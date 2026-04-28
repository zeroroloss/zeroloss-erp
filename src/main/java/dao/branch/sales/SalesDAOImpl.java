package dao.branch.sales;

import dto.branch.sales.DailySalesDTO;
import dto.branch.sales.HourlySalesDTO;
import dto.branch.sales.MenuSalesDTO;
import dto.branch.sales.SalesSummaryDTO;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.MyBatisSqlSessionFactory;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO (Data Access Object) Implementation
 * - SalesDAO 인터페이스의 구현체
 * - MyBatis를 사용하여 실제 데이터베이스 작업을 수행
 */
public class SalesDAOImpl implements SalesDAO {

    private final SqlSessionFactory sqlSessionFactory = MyBatisSqlSessionFactory.getSqlSessionFactory();

    @Override
    public SalesSummaryDTO getSalesSummary(int branchCode) {
        System.out.println("[Log] SalesDAO - getSalesSummary 호출, branchCode: " + branchCode);
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            SalesSummaryDTO summary = sqlSession.selectOne("mapper.branch.sales.SalesMapper.getSalesSummary", branchCode);
            System.out.println("[Log] SalesDAO - DB 조회 결과: " + summary);
            return summary;
        }
    }

    @Override
    public List<DailySalesDTO> getDailySales(int branchCode, LocalDate startDate, LocalDate endDate) {
        System.out.println("[Log] SalesDAO - getDailySales 호출, branchCode: " + branchCode + ", startDate: " + startDate + ", endDate: " + endDate);
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("branchCode", branchCode);
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            List<DailySalesDTO> result = sqlSession.selectList("mapper.branch.sales.SalesMapper.getDailySales", params);
            System.out.println("[Log] SalesDAO - DB 조회 결과 (일별): " + result.size() + "개 행");
            return result;
        }
    }

    @Override
    public List<HourlySalesDTO> getHourlySales(int branchCode, LocalDate targetDate) {
        System.out.println("[Log] SalesDAO - getHourlySales 호출, branchCode: " + branchCode + ", targetDate: " + targetDate);
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("branchCode", branchCode);
            params.put("targetDate", targetDate);
            List<HourlySalesDTO> result = sqlSession.selectList("mapper.branch.sales.SalesMapper.getHourlySales", params);
            System.out.println("[Log] SalesDAO - DB 조회 결과 (시간별): " + result.size() + "개 행");
            return result;
        }
    }

    @Override
    public List<MenuSalesDTO> getMenuSales(int branchCode, LocalDate targetDate) {
        System.out.println("[Log] SalesDAO - getMenuSales 호출, branchCode: " + branchCode + ", targetDate: " + targetDate);
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("branchCode", branchCode);
            params.put("targetDate", targetDate);
            List<MenuSalesDTO> result = sqlSession.selectList("mapper.branch.sales.SalesMapper.getMenuSales", params);
            System.out.println("[Log] SalesDAO - DB 조회 결과 (메뉴별): " + result.size() + "개 행");
            return result;
        }
    }
}
