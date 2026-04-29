package dto.hq.sales;

public class HqTodaySalesSummaryDTO {
    private long totalSales;
    private int totalOrders;
    private String popularMenu;
    private long monthlyCumulativeSales;

    public HqTodaySalesSummaryDTO() {
    }

    public HqTodaySalesSummaryDTO(long totalSales, int totalOrders, String popularMenu, long monthlyCumulativeSales) {
        this.totalSales = totalSales;
        this.totalOrders = totalOrders;
        this.popularMenu = popularMenu;
        this.monthlyCumulativeSales = monthlyCumulativeSales;
    }

    public long getTotalSales() {
        return totalSales;
    }

    public void setTotalSales(long totalSales) {
        this.totalSales = totalSales;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public String getPopularMenu() {
        return popularMenu;
    }

    public void setPopularMenu(String popularMenu) {
        this.popularMenu = popularMenu;
    }

    public long getMonthlyCumulativeSales() {
        return monthlyCumulativeSales;
    }

    public void setMonthlyCumulativeSales(long monthlyCumulativeSales) {
        this.monthlyCumulativeSales = monthlyCumulativeSales;
    }

    @Override
    public String toString() {
        return "HqTodaySalesSummaryDTO{" +
                "totalSales=" + totalSales +
                ", totalOrders=" + totalOrders +
                ", popularMenu='" + popularMenu + '\'' +
                ", monthlyCumulativeSales=" + monthlyCumulativeSales +
                '}';
    }
}
