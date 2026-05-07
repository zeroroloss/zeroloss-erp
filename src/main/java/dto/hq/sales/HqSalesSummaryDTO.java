package dto.hq.sales;

public class HqSalesSummaryDTO {
    private long totalSales;           // 전지점 통합 총 매출 (오늘)
    private int totalOrders;           // 총 주문건 수 (오늘)
    private String popularMenu;        // 인기 메뉴명
    private long monthlyCumulativeSales; // 이번달 누적 매출

    public HqSalesSummaryDTO() {}

    public HqSalesSummaryDTO(long totalSales, int totalOrders, String popularMenu, long monthlyCumulativeSales) {
        this.totalSales = totalSales;
        this.totalOrders = totalOrders;
        this.popularMenu = popularMenu;
        this.monthlyCumulativeSales = monthlyCumulativeSales;
    }

    // Getters and Setters
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
}

