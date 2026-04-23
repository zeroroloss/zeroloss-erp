package dto;

import java.util.List;

public class RecipeViewDTO {
    private String id;
    private String name;
    private String category;
    private Integer categoryId;
    private String subCategoryCode;
    private String subCategoryName; // 추가
    private Integer price;
    private Integer cost;
    private String image;
    private Boolean isActive;
    private String description;
    private String instructions;

    private List<RecipeIngredientDTO> ingredients;

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }
    public String getSubCategoryCode() { return subCategoryCode; }
    public void setSubCategoryCode(String subCategoryCode) { this.subCategoryCode = subCategoryCode; }
    public String getSubCategoryName() { return subCategoryName; } // 추가
    public void setSubCategoryName(String subCategoryName) { this.subCategoryName = subCategoryName; } // 추가
    public Integer getPrice() { return price; }
    public void setPrice(Integer price) { this.price = price; }
    public Integer getCost() { return cost; }
    public void setCost(Integer cost) { this.cost = cost; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }
    public List<RecipeIngredientDTO> getIngredients() { return ingredients; }
    public void setIngredients(List<RecipeIngredientDTO> ingredients) { this.ingredients = ingredients; }

    public static class RecipeIngredientDTO {
        private String materialCode;
        private String name;
        private Double quantity;
        private String unit;
        private Integer materialPrice; // 추가

        // Getters and Setters
        public String getMaterialCode() { return materialCode; }
        public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public Double getQuantity() { return quantity; }
        public void setQuantity(Double quantity) { this.quantity = quantity; }
        public String getUnit() { return unit; }
        public void setUnit(String unit) { this.unit = unit; }
        public Integer getMaterialPrice() { return materialPrice; } // 추가
        public void setMaterialPrice(Integer materialPrice) { this.materialPrice = materialPrice; } // 추가
    }
}
