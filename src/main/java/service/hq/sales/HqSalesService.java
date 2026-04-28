package service.hq.sales;

import dto.BranchDTO;
import dto.branch.sales.DailySalesDTO;
import dto.branch.sales.HourlySalesDTO;
import dto.branch.sales.MenuSalesDTO;

import java.time.LocalDate;
import java.util.List;

public interface HqSalesService {
    /**
     * 활성화된 직영점 목록을 가져옵니다.
     * @return 직영점 DTO 리스트
     */
    List<BranchDTO> getActiveBranches();

    /**
     * 특정 지점 또는 전체 지점의 일별 매출 데이터를 조회합니다.
     * @param branchCode 지점 코드 ('all'인 경우 전체)
     * @param targetDate 기준 날짜
     * @return 일별 매출 DTO 리스트
     */
    List<DailySalesDTO> getDailySales(String branchCode, LocalDate targetDate);

    /**
     * 특정 지점 또는 전체 지점의 기간별 매출 데이터를 조회합니다.
     * @param branchCode 지점 코드 ('all'인 경우 전체)
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @return 일별 매출 DTO 리스트
     */
    List<DailySalesDTO> getPeriodSales(String branchCode, LocalDate startDate, LocalDate endDate);

    /**
     * 특정 지점 또는 전체 지점의 시간대별 매출 데이터를 조회합니다.
     * @param branchCode 지점 코드 ('all'인 경우 전체)
     * @param targetDate 기준 날짜
     * @return 시간대별 매출 DTO 리스트
     */
    List<HourlySalesDTO> getHourlySales(String branchCode, LocalDate targetDate);

    /**
     * 특정 지점 또는 전체 지점의 메뉴별 매출 데이터를 조회합니다.
     * @param branchCode 지점 코드 ('all'인 경우 전체)
     * @param targetDate 기준 날짜
     * @return 메뉴별 매출 DTO 리스트
     */
    List<MenuSalesDTO> getMenuSales(String branchCode, LocalDate targetDate);
}
