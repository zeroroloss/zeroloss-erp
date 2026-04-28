package dao.hq.sales;

import dto.BranchDTO;
import dto.branch.sales.DailySalesDTO;
import dto.branch.sales.HourlySalesDTO;
import dto.branch.sales.MenuSalesDTO;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

public interface HqSalesDAO {
    /**
     * 활성화된 모든 직영점 목록을 조회합니다.
     * @return 직영점 DTO 리스트
     */
    List<BranchDTO> selectActiveBranches();

    /**
     * 지정된 기간과 지점 조건에 맞는 일별 매출 데이터를 조회합니다.
     * @param branchCode 지점 코드 ('all'인 경우 전체)
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @return 일별 매출 DTO 리스트
     */
    List<DailySalesDTO> getDailySales(@Param("branchCode") String branchCode, @Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

    /**
     * 지정된 날짜와 지점 조건에 맞는 시간대별 매출 데이터를 조회합니다.
     * @param branchCode 지점 코드 ('all'인 경우 전체)
     * @param targetDate 기준 날짜
     * @return 시간대별 매출 DTO 리스트
     */
    List<HourlySalesDTO> getHourlySales(@Param("branchCode") String branchCode, @Param("targetDate") LocalDate targetDate);

    /**
     * 지정된 날짜와 지점 조건에 맞는 메뉴별 매출 데이터를 조회합니다.
     * @param branchCode 지점 코드 ('all'인 경우 전체)
     * @param targetDate 기준 날짜
     * @return 메뉴별 매출 DTO 리스트
     */
    List<MenuSalesDTO> getMenuSales(@Param("branchCode") String branchCode, @Param("targetDate") LocalDate targetDate);
}
