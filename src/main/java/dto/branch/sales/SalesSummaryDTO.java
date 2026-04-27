package dto.branch.sales;

import java.text.DecimalFormat;

/**
 * DTO (Data Transfer Object)
 * - 직영점 매출 조회 페이지의 '오늘의 매출 요약' 섹션에 사용될 데이터를 담는 클래스
 * - /branch/sales/summary 요청의 응답 데이터 구조
 */
public class SalesSummaryDTO {
    private int todaySales; // 오늘 총 매출
    private int todayOrders; // 오늘 총 주문 수
    private String topMenu; // 오늘의 인기 메뉴
    private int monthlySales; // 이번 달 총 매출

    // Getters
    public int getTodaySales() {
        return todaySales;
    }

    public int getTodayOrders() {
        return todayOrders;
    }

    public String getTopMenu() {
        return topMenu;
    }

    public int getMonthlySales() {
        return monthlySales;
    }

    // Setters
    public void setTodaySales(int todaySales) {
        this.todaySales = todaySales;
    }

    public void setTodayOrders(int todayOrders) {
        this.todayOrders = todayOrders;
    }

    public void setTopMenu(String topMenu) {
        this.topMenu = topMenu;
    }

    public void setMonthlySales(int monthlySales) {
        this.monthlySales = monthlySales;
    }

    // 금액 포맷팅을 위한 편의 메소드
    public String getFormattedTodaySales() {
        return formatAmount(this.todaySales);
    }

    public String getFormattedMonthlySales() {
        return formatAmount(this.monthlySales);
    }

    private String formatAmount(int amount) {
        DecimalFormat formatter = new DecimalFormat("₩#,###");
        return formatter.format(amount);
    }

    @Override
    public String toString() {
        return "SalesSummaryDTO{" +
                "todaySales=" + todaySales +
                ", todayOrders=" + todayOrders +
                ", topMenu='" + topMenu + '\'' +
                ", monthlySales=" + monthlySales +
                '}';
    }
}
