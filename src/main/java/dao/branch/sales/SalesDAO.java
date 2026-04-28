package dao.branch.sales;

import dto.branch.sales.DailySalesDTO;
import dto.branch.sales.HourlySalesDTO;
import dto.branch.sales.MenuSalesDTO;
import dto.branch.sales.SalesSummaryDTO;

import java.time.LocalDate;
import java.util.List;

/**
 * DAO (Data Access Object) Interface
 * - 직영점 매출 관련 데이터베이스 접근을 위한 명세
 */
public interface SalesDAO {

    /**
     * 오늘의 매출 요약 정보를 데이터베이스에서 조회합니다.
     * @param branchCode 조회할 직영점의 코드
     * @return SalesSummaryDTO 매출 요약 정보
     */
    SalesSummaryDTO getSalesSummary(int branchCode);

    /**
     * 지정된 기간 동안의 일별 매출 데이터를 조회합니다.
     * @param branchCode 조회할 직영점의 코드
     * @param startDate  조회 시작일
     * @param endDate    조회 종료일
     * @return DailySalesDTO 객체 리스트
     */
    List<DailySalesDTO> getDailySales(int branchCode, LocalDate startDate, LocalDate endDate);

    /**
     * 특정 날짜의 시간대별 매출 데이터를 조회합니다.
     * @param branchCode 조회할 직영점의 코드
     * @param targetDate 조회할 날짜
     * @return HourlySalesDTO 객체 리스트
     */
    List<HourlySalesDTO> getHourlySales(int branchCode, LocalDate targetDate);

    /**
     * 특정 날짜의 메뉴별 매출 데이터를 조회합니다.
     * @param branchCode 조회할 직영점의 코드
     * @param targetDate 조회할 날짜
     * @return MenuSalesDTO 객체 리스트
     */
    List<MenuSalesDTO> getMenuSales(int branchCode, LocalDate targetDate);
}
