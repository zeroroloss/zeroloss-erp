package dto.branch.sales;

public class HourlySalesDTO {
    private int hour; // 시간 (0-23)
    private long totalSales; // 해당 시간의 총 매출
    private int totalOrders; // 해당 시간의 총 주문 건수

    // Getters and Setters
    public int getHour() {
        return hour;
    }

    public void setHour(int hour) {
        this.hour = hour;
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

    @Override
    public String toString() {
        return "HourlySalesDTO{" +
               "hour=" + hour +
               ", totalSales=" + totalSales +
               ", totalOrders=" + totalOrders +
               '}';
    }
}
