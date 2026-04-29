package service.hq.sales;

import dao.hq.sales.SalesRankingDao;
import dao.hq.sales.SalesRankingDaoImpl;
import dto.hq.sales.DailySalesTrendDto;
import dto.hq.sales.HourlySalesTrendDto;
import dto.hq.sales.MenuCategoryDto;
import dto.hq.sales.MenuDto;
import dto.hq.sales.SalesRankingDto;

import java.util.List;

public class SalesRankingServiceImpl implements SalesRankingService {

    private SalesRankingDao salesRankingDao;

    public SalesRankingServiceImpl() {
        this.salesRankingDao = new SalesRankingDaoImpl();
    }

    @Override
    public List<SalesRankingDto> getSalesRanking(String startDate, String endDate) {
        return salesRankingDao.getSalesRanking(startDate, endDate);
    }

    @Override
    public List<SalesRankingDto> getSalesQuantityRanking(String startDate, String endDate) {
        return salesRankingDao.getSalesQuantityRanking(startDate, endDate);
    }

    // 🟢 탭 2: 전사 메뉴 매출액 랭킹 로직 연결
    @Override
    public List<SalesRankingDto> getMenuSalesRanking(String startDate, String endDate) {
        return salesRankingDao.getMenuSalesRanking(startDate, endDate);
    }

    // 🟢 탭 2: 전사 메뉴 판매량 랭킹 로직 연결
    @Override
    public List<SalesRankingDto> getMenuQuantityRanking(String startDate, String endDate) {
        return salesRankingDao.getMenuQuantityRanking(startDate, endDate);
    }

    @Override
    public List<SalesRankingDto> getSpecificMenuSalesRanking(String startDate, String endDate, String recipeCode) {
        return salesRankingDao.getSpecificMenuSalesRanking(startDate, endDate, recipeCode);
    }

    @Override
    public List<SalesRankingDto> getSpecificMenuQuantityRanking(String startDate, String endDate, String recipeCode) {
        return salesRankingDao.getSpecificMenuQuantityRanking(startDate, endDate, recipeCode);
    }

    @Override
    public List<MenuCategoryDto> getAllMenuCategories() {
        return salesRankingDao.getAllMenuCategories();
    }

    @Override
    public List<MenuDto> getMenusByCategory(int categoryCode) {
        return salesRankingDao.getMenusByCategory(categoryCode);
    }

    @Override
    public List<HourlySalesTrendDto> getHourlySalesTrend(String startDate, String endDate) {
        return salesRankingDao.getHourlySalesTrend(startDate, endDate);
    }

    @Override
    public List<DailySalesTrendDto> getDailySalesTrend(String startDate, String endDate) {
        return salesRankingDao.getDailySalesTrend(startDate, endDate);
    }
}
