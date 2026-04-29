package dto.hq.sales;

public class MenuDto {
    private String recipeCode;
    private String recipeName;
    private String categoryCode;

    // Constructors
    public MenuDto() {}

    public MenuDto(String recipeCode, String recipeName, String categoryCode) {
        this.recipeCode = recipeCode;
        this.recipeName = recipeName;
        this.categoryCode = categoryCode;
    }

    // Getters and Setters
    public String getRecipeCode() {
        return recipeCode;
    }

    public void setRecipeCode(String recipeCode) {
        this.recipeCode = recipeCode;
    }

    public String getRecipeName() {
        return recipeName;
    }

    public void setRecipeName(String recipeName) {
        this.recipeName = recipeName;
    }

    public String getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }

    @Override
    public String toString() {
        return "MenuDto{" +
               "recipeCode='" + recipeCode + '\'' +
               ", recipeName='" + recipeName + '\'' +
               ", categoryCode='" + categoryCode + '\'' +
               '}';
    }
}
