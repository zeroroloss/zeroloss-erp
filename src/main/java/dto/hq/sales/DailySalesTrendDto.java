package dto.hq.sales;

public class DailySalesTrendDto {
    private int dayOfWeek; // 1=Sunday, 2=Monday, ..., 7=Saturday
    private String dayName; // "일", "월", "화", ...
    private long totalSales;
    private long totalQuantity;

    public DailySalesTrendDto() {}

    public DailySalesTrendDto(int dayOfWeek, String dayName, long totalSales, long totalQuantity) {
        this.dayOfWeek = dayOfWeek;
        this.dayName = dayName;
        this.totalSales = totalSales;
        this.totalQuantity = totalQuantity;
    }

    public int getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(int dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public String getDayName() {
        return dayName;
    }

    public void setDayName(String dayName) {
        this.dayName = dayName;
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
        return "DailySalesTrendDto{" +
               "dayOfWeek=" + dayOfWeek +
               ", dayName='" + dayName + '\'' +
               ", totalSales=" + totalSales +
               ", totalQuantity=" + totalQuantity +
               '}';
    }
}
