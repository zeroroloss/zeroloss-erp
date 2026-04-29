package service.hq.sales;

import dao.hq.sales.HqSalesDAO;
import dao.hq.sales.HqSalesDAOImpl;
import dto.BranchDTO;
import dto.branch.sales.DailySalesDTO;
import dto.branch.sales.HourlySalesDTO;
import dto.branch.sales.MenuSalesDTO;
import dto.hq.sales.*;

import java.time.LocalDate;
import java.util.List;

public class HqSalesServiceImpl implements HqSalesService {

    private final HqSalesDAO hqSalesDAO = new HqSalesDAOImpl();

    @Override
    public List<BranchDTO> getActiveBranches() {
        return hqSalesDAO.selectActiveBranches();
    }

    @Override
    public List<DailySalesDTO> getDailySales(String branchCode, LocalDate targetDate) {
        LocalDate startDate = targetDate.minusDays(6);
        LocalDate endDate = targetDate;
        return hqSalesDAO.getDailySales(branchCode, startDate, endDate);
    }

    @Override
    public List<DailySalesDTO> getPeriodSales(String branchCode, LocalDate startDate, LocalDate endDate) {
        return hqSalesDAO.getDailySales(branchCode, startDate, endDate);
    }

    @Override
    public List<HourlySalesDTO> getHourlySales(String branchCode, LocalDate targetDate) {
        return hqSalesDAO.getHourlySales(branchCode, targetDate);
    }

    @Override
    public List<MenuSalesDTO> getMenuSales(String branchCode, LocalDate targetDate, Integer categoryId, String subCategoryCode) {
        List<MenuSalesDTO> menuSales = hqSalesDAO.getMenuSales(branchCode, targetDate, categoryId, subCategoryCode);

        if (menuSales != null && !menuSales.isEmpty()) {
            long totalSalesSum = menuSales.stream().mapToLong(MenuSalesDTO::getTotalSales).sum();
            if (totalSalesSum > 0) {
                menuSales.forEach(menu -> {
                    double share = (double) menu.getTotalSales() / totalSalesSum * 100;
                    menu.setSalesShare(share);
                });
            }
        }
        return menuSales;
    }

    @Override
    public HqSalesSummaryDTO getHeadquartersSalesSummary(LocalDate targetDate) {
        return hqSalesDAO.getHeadquartersSalesSummary(targetDate);
    }

    @Override
    public HqTodaySalesSummaryDTO getTodaySalesSummary(LocalDate targetDate) {
        return hqSalesDAO.getTodaySalesSummary(targetDate);
    }

    @Override
    public List<CategoryDTO> getAllMainCategories() {
        return hqSalesDAO.getAllMainCategories();
    }

    @Override
    public List<SubCategoryDTO> getSubCategoriesByMainCategory(int mainCategoryId) {
        return hqSalesDAO.getSubCategoriesByMainCategory(mainCategoryId);
    }

    @Override
    public List<MenuSalesDTO> getMenusByCategory(int categoryId) {
        return hqSalesDAO.getMenusByCategory(categoryId);
    }

    @Override
    public List<MenuSalesRankDTO> getMenuSalesRanksByCategory(LocalDate targetDate, int categoryId) {
        List<MenuSalesRankDTO> ranks = hqSalesDAO.getMenuSalesRanksByCategory(targetDate, categoryId);
        if (ranks != null && !ranks.isEmpty()) {
            long totalCategorySales = ranks.stream().mapToLong(MenuSalesRankDTO::getTotalSales).sum();
            if (totalCategorySales > 0) {
                ranks.forEach(rank -> {
                    double share = (double) rank.getTotalSales() / totalCategorySales * 100;
                    rank.setCategoryShare(share);
                });
            }
        }
        return ranks;
    }

    @Override
    public List<BranchMenuSalesRankDTO> getBranchSalesRanksByMenu(LocalDate startDate, LocalDate endDate, String recipeCode) {
        List<BranchMenuSalesRankDTO> ranks = hqSalesDAO.getBranchSalesRanksByMenu(startDate, endDate, recipeCode);
        if (ranks != null && !ranks.isEmpty()) {
            long totalMenuSales = ranks.stream().mapToLong(BranchMenuSalesRankDTO::getTotalSales).sum();
            if (totalMenuSales > 0) {
                ranks.forEach(rank -> {
                    double share = (double) rank.getTotalSales() / totalMenuSales * 100;
                    rank.setCompanyShare(share);
                });
            }
        }
        return ranks;
    }
}
