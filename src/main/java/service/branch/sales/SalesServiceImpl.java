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
        // 기준 날짜로부터 6일 전 날짜를 시작일로 설정 (총 7일간의 데이터)
        LocalDate startDate = targetDate.minusDays(6);
        LocalDate endDate = targetDate;

        System.out.println("[Log] SalesService - getDailySales 호출, branchCode: " + branchCode + ", 조회 기간: " + startDate + " ~ " + endDate);

        // DAO를 통해 해당 기간의 매출 데이터를 조회
        return salesDAO.getDailySales(branchCode, startDate, endDate);
    }
}
