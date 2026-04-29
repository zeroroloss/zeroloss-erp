package dto.hq.sales;

public class BranchMenuSalesRankDTO {
    private int rank;
    private String branchName;
    private int quantity;
    private long totalSales;
    private double companyShare;

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

    public double getCompanyShare() {
        return companyShare;
    }

    public void setCompanyShare(double companyShare) {
        this.companyShare = companyShare;
    }
}
