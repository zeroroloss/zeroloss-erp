package service.branch.sales;

import dao.branch.sales.SalesDAO;
import dao.branch.sales.SalesDAOImpl;
import dto.branch.sales.DailySalesDTO;
import dto.branch.sales.SalesSummaryDTO;

import java.time.LocalDate;
import java.util.List;

/**
 * Service Implementation
 * - SalesService 인터페이스의 구현체
 * - 비즈니스 로직을 실제로 처리하며, DAO를 통해 데이터베이스와 상호작용
 */
public class SalesServiceImpl implements SalesService {

    private final SalesDAO salesDAO = new SalesDAOImpl();

    @Override
    public SalesSummaryDTO getSalesSummary(int branchCode) {
        return salesDAO.getSalesSummary(branchCode);
    }

    @Override
    public List<DailySalesDTO> getDailySales(int branchCode, LocalDate targetDate) {
        LocalDate startDate = targetDate.minusDays(6);
        LocalDate endDate = targetDate;

        System.out.println("[Log] SalesService - getDailySales 호출, branchCode: " + branchCode + ", 조회 기간: " + startDate + " ~ " + endDate);
        return salesDAO.getDailySales(branchCode, startDate, endDate);
    }

    @Override
    public List<DailySalesDTO> getPeriodSales(int branchCode, LocalDate startDate, LocalDate endDate) {
        System.out.println("[Log] SalesService - getPeriodSales 호출, branchCode: " + branchCode + ", 조회 기간: " + startDate + " ~ " + endDate);
        return salesDAO.getDailySales(branchCode, startDate, endDate);
    }
}
