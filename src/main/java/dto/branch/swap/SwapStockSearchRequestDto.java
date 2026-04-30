package dto.branch.swap;

public class SwapStockSearchRequestDto {
    private int currentBranchCode;
    private String materialCode;
    private int requiredQty;
    private int distance;

    public SwapStockSearchRequestDto() {
    }

    public SwapStockSearchRequestDto(int currentBranchCode, String materialCode, int requiredQty, int distance) {
        this.currentBranchCode = currentBranchCode;
        this.materialCode = materialCode;
        this.requiredQty = requiredQty;
        this.distance = distance;
    }

    // Getters
    public int getCurrentBranchCode() { return currentBranchCode; }
    public String getMaterialCode() { return materialCode; }
    public int getRequiredQty() { return requiredQty; }
    public int getDistance() { return distance; }

    // Setters
    public void setCurrentBranchCode(int currentBranchCode) { this.currentBranchCode = currentBranchCode; }
    public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }
    public void setRequiredQty(int requiredQty) { this.requiredQty = requiredQty; }
    public void setDistance(int distance) { this.distance = distance; }
}
