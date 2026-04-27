package dto.branch.sales;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.Locale;

/**
 * DTO for Daily Sales
 * - 일별 매출 데이터를 담는 클래스
 * - Chart.js 그래프와 하단 테이블에 사용될 데이터를 포함
 */
public class DailySalesDTO {
    private LocalDate saleDate;     // 날짜
    private long totalSales;        // 일 매출액
    private int totalOrders;        // 일 주문 건수
    private long cumulativeSales;   // 누적 매출액

    // Getters
    public LocalDate getSaleDate() {
        return saleDate;
    }

    public long getTotalSales() {
        return totalSales;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public long getCumulativeSales() {
        return cumulativeSales;
    }

    // Setters
    public void setSaleDate(LocalDate saleDate) {
        this.saleDate = saleDate;
    }

    public void setTotalSales(long totalSales) {
        this.totalSales = totalSales;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public void setCumulativeSales(long cumulativeSales) {
        this.cumulativeSales = cumulativeSales;
    }

    // JSP에서 EL로 쉽게 접근하기 위한 추가 Getter 메소드

    /**
     * 요일을 한글로 반환 (예: "월", "화")
     */
    public String getDayOfWeek() {
        if (saleDate == null) {
            return "";
        }
        DayOfWeek day = saleDate.getDayOfWeek();
        return day.getDisplayName(TextStyle.SHORT, Locale.KOREAN);
    }

    /**
     * 객단가(주문 1건당 평균 매출액)를 계산하여 반환
     */
    public long getAvgPricePerOrder() {
        if (totalOrders == 0) {
            return 0;
        }
        return totalSales / totalOrders;
    }

    /**
     * 주말 여부를 반환 (토요일 또는 일요일)
     */
    public boolean isWeekend() {
        if (saleDate == null) {
            return false;
        }
        DayOfWeek day = saleDate.getDayOfWeek();
        return day == DayOfWeek.SATURDAY || day == DayOfWeek.SUNDAY;
    }
}
