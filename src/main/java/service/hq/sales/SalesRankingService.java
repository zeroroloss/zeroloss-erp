package service.hq.sales;

import dto.hq.sales.DailySalesTrendDto;
import dto.hq.sales.HourlySalesTrendDto;
import dto.hq.sales.MenuCategoryDto;
import dto.hq.sales.MenuDto;
import dto.hq.sales.SalesRankingDto;
import java.util.List;

public interface SalesRankingService {
    // 기존 지점 종합 랭킹
    List<SalesRankingDto> getSalesRanking(String startDate, String endDate);
    List<SalesRankingDto> getSalesQuantityRanking(String startDate, String endDate);

    // 🟢 탭 2: 새로 추가된 전사 메뉴별 랭킹
    List<SalesRankingDto> getMenuSalesRanking(String startDate, String endDate);
    List<SalesRankingDto> getMenuQuantityRanking(String startDate, String endDate);

    // 🟢 탭 3: 특정 메뉴 집중 분석
    List<SalesRankingDto> getSpecificMenuSalesRanking(String startDate, String endDate, String recipeCode);
    List<SalesRankingDto> getSpecificMenuQuantityRanking(String startDate, String endDate, String recipeCode);

    // 🟢 추가: 메뉴 카테고리 목록 조회
    List<MenuCategoryDto> getAllMenuCategories();

    // 🟢 추가: 특정 카테고리에 속하는 메뉴 목록 조회
    List<MenuDto> getMenusByCategory(int categoryCode);

    // 🟢 추가: 시간별 트렌드 조회
    List<HourlySalesTrendDto> getHourlySalesTrend(String startDate, String endDate);

    // 🟢 추가: 요일별 트렌드 조회
    List<DailySalesTrendDto> getDailySalesTrend(String startDate, String endDate);
}
