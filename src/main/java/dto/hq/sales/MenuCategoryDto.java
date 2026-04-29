package dto.hq.sales;

public class MenuCategoryDto {
    private String categoryCode;
    private String categoryName;

    // Constructors
    public MenuCategoryDto() {}

    public MenuCategoryDto(String categoryCode, String categoryName) {
        this.categoryCode = categoryCode;
        this.categoryName = categoryName;
    }

    // Getters and Setters
    public String getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    @Override
    public String toString() {
        return "MenuCategoryDto{" +
               "categoryCode='" + categoryCode + '\'' +
               ", categoryName='" + categoryName + '\'' +
               '}';
    }
}
