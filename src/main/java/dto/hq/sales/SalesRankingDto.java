package dto.hq.sales;

public class SalesRankingDto {
    private int rank;
    private String branchName;
    private long totalSales;
    private long totalQuantity; // 새로 추가

    public SalesRankingDto() {
    }

    public SalesRankingDto(int rank, String branchName, long totalSales, long totalQuantity) {
        this.rank = rank;
        this.branchName = branchName;
        this.totalSales = totalSales;
        this.totalQuantity = totalQuantity;
    }

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
