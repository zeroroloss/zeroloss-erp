package service.branch.sales;

import dto.branch.sales.DailySalesDTO;
import dto.branch.sales.SalesSummaryDTO;

import java.time.LocalDate;
import java.util.List;

/**
 * Service Interface
 * - 직영점 매출 관련 비즈니스 로직에 대한 명세
 */
public interface SalesService {

    /**
     * 오늘의 매출 요약 정보를 조회하는 비즈니스 로직을 수행합니다.
     * @param branchCode 조회할 직영점의 코드
     * @return SalesSummaryDTO 매출 요약 정보
     */
    SalesSummaryDTO getSalesSummary(int branchCode);

    /**
     * 특정 날짜를 기준으로 최근 7일간의 일별 매출 데이터를 조회합니다.
     * @param branchCode 조회할 직영점의 코드
     * @param targetDate 기준 날짜
     * @return 7일간의 DailySalesDTO 객체 리스트
     */
    List<DailySalesDTO> getDailySales(int branchCode, LocalDate targetDate);
}
