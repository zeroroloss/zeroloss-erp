package service.hq.sales;

import dao.hq.sales.HqSalesDAO;
import dao.hq.sales.HqSalesDAOImpl;
import dto.BranchDTO;
import dto.branch.sales.DailySalesDTO;
import dto.branch.sales.HourlySalesDTO;
import dto.branch.sales.MenuSalesDTO;

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
    public List<MenuSalesDTO> getMenuSales(String branchCode, LocalDate targetDate) {
        List<MenuSalesDTO> menuSales = hqSalesDAO.getMenuSales(branchCode, targetDate);

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
}
