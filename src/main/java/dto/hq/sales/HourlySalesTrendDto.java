package dto.hq.sales;

public class HourlySalesTrendDto {
    private int hour; // 0-23
    private long totalSales;
    private long totalQuantity;

    public HourlySalesTrendDto() {}

    public HourlySalesTrendDto(int hour, long totalSales, long totalQuantity) {
        this.hour = hour;
        this.totalSales = totalSales;
        this.totalQuantity = totalQuantity;
    }

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

    public long getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(long totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    @Override
    public String toString() {
        return "HourlySalesTrendDto{" +
               "hour=" + hour +
               ", totalSales=" + totalSales +
               ", totalQuantity=" + totalQuantity +
               '}';
    }
}
