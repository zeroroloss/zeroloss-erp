package service.hq.sales;

import dto.BranchDTO;
import dto.branch.sales.DailySalesDTO;
import dto.branch.sales.HourlySalesDTO;
import dto.branch.sales.MenuSalesDTO;
import dto.hq.sales.*;

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
     * 특정 조건에 맞는 메뉴별 매출 데이터를 조회합니다.
     * @param branchCode 지점 코드 ('all'인 경우 전체)
     * @param targetDate 기준 날짜
     * @param categoryId 메인 카테고리 ID
     * @param subCategoryCode 서브 카테고리 코드
     * @return 메뉴별 매출 DTO 리스트
     */
    List<MenuSalesDTO> getMenuSales(String branchCode, LocalDate targetDate, Integer categoryId, String subCategoryCode);

    /**
     * 본사 매출 요약 정보를 조회합니다 (전지점 통합).
     * @param targetDate 기준 날짜
     * @return 본사 매출 요약 DTO
     */
    HqSalesSummaryDTO getHeadquartersSalesSummary(LocalDate targetDate);

    /**
     * 오늘의 본사 매출 요약 정보를 조회합니다.
     * @param targetDate 기준 날짜
     * @return 오늘의 본사 매출 요약 DTO
     */
    HqTodaySalesSummaryDTO getTodaySalesSummary(LocalDate targetDate);

    /**
     * 모든 메인 카테고리를 가져옵니다.
     * @return 메인 카테고리 리스트
     */
    List<CategoryDTO> getAllMainCategories();

    /**
     * 특정 메인 카테고리에 속한 서브 카테고리를 조회합니다.
     * @param mainCategoryId 메인 카테고리 ID
     * @return 서브 카테고리 DTO 리스트
     */
    List<SubCategoryDTO> getSubCategoriesByMainCategory(int mainCategoryId);

    /**
     * 특정 카테고리에 속한 메뉴 목록을 가져옵니다.
     * @param categoryId 카테고리 ID
     * @return 메뉴 DTO 리스트
     */
    List<MenuSalesDTO> getMenusByCategory(int categoryId);

    /**
     * 특정 카테고리 내 메뉴별 매출 랭킹을 조회합니다.
     * @param targetDate 기준 날짜
     * @param categoryId 카테고리 ID
     * @return 메뉴별 매출 랭킹 DTO 리스트
     */
    List<MenuSalesRankDTO> getMenuSalesRanksByCategory(LocalDate targetDate, int categoryId);

    /**
     * 특정 메뉴의 지점별 판매 랭킹을 조회합니다.
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @param recipeCode 레시피 코드
     * @return 지점별 메뉴 판매 랭킹 DTO 리스트
     */
    List<BranchMenuSalesRankDTO> getBranchSalesRanksByMenu(LocalDate startDate, LocalDate endDate, String recipeCode);
}
