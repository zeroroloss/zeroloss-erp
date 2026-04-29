package dto.branch.sales;

public class MenuSalesDTO {
    private String recipeCode; // Added recipeCode field
    private String menuName;
    private int quantity;
    private long totalSales;
    private double salesShare;

    // Getters and Setters
    public String getRecipeCode() {
        return recipeCode;
    }

    public void setRecipeCode(String recipeCode) {
        this.recipeCode = recipeCode;
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

    public double getSalesShare() {
        return salesShare;
    }

    public void setSalesShare(double salesShare) {
        this.salesShare = salesShare;
    }

    @Override
    public String toString() {
        return "MenuSalesDTO{" +
                "recipeCode='" + recipeCode + '\'' +
                ", menuName='" + menuName + '\'' +
                ", quantity=" + quantity +
                ", totalSales=" + totalSales +
                ", salesShare=" + salesShare +
                '}';
    }
}
