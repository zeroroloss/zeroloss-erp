package dto.hq.sales;

public class SalesRankingDto {
    private int rank;
    private String branchName;
    private long totalSales;
    private long totalQuantity;
    private String menuName; // 전사 메뉴별 랭킹

    public SalesRankingDto() {
    }

    public SalesRankingDto(int rank, String branchName, long totalSales, long totalQuantity) {
        this.rank = rank;
        this.branchName = branchName;
        this.totalSales = totalSales;
        this.totalQuantity = totalQuantity;
    }

    //게터세터

    public String getMenuName() { return menuName; }

    public void setMenuName(String menuName) { this.menuName = menuName; }

    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
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
        return "SalesRankingDto{" +
               "rank=" + rank +
               ", branchName='" + branchName + '\'' +
               ", totalSales=" + totalSales +
               ", totalQuantity=" + totalQuantity +
               '}';
    }
}
