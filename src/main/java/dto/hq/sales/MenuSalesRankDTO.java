package dto.hq.sales;

public class MenuSalesRankDTO {
    private int rank;
    private String menuName;
    private int quantity;
    private long totalSales;
    private double categoryShare;

    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public long getTotalSales() {
        return totalSales;
    }

    public void setTotalSales(long totalSales) {
        this.totalSales = totalSales;
    }

    public double getCategoryShare() {
        return categoryShare;
    }

    public void setCategoryShare(double categoryShare) {
        this.categoryShare = categoryShare;
    }
}
