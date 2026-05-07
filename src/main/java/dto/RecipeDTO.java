package dto;

public class RecipeDTO {
	private String recipeCode;
	private Integer categoryId;
	private String subCategoryCode;
	private String name;
	private Integer price;
	private String instruction;
	private String imgUrl;
	private Boolean isActive;

	public RecipeDTO() {}

	public RecipeDTO(String recipeCode, Integer categoryId, String subCategoryCode, String name, Integer price, String instruction, String imgUrl, Boolean isActive) {
		super();
		this.recipeCode = recipeCode;
		this.categoryId = categoryId;
		this.subCategoryCode = subCategoryCode;
		this.name = name;
		this.price = price;
		this.instruction = instruction;
		this.imgUrl = imgUrl;
		this.isActive = isActive;
	}

	public String getRecipeCode() {
		return recipeCode;
	}

	public void setRecipeCode(String recipeCode) {
		this.recipeCode = recipeCode;
	}

	public Integer getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(Integer categoryId) {
		this.categoryId = categoryId;
	}

	public String getSubCategoryCode() {
		return subCategoryCode;
	}

	public void setSubCategoryCode(String subCategoryCode) {
		this.subCategoryCode = subCategoryCode;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getPrice() {
		return price;
	}

	public void setPrice(Integer price) {
		this.price = price;
	}

	public String getInstruction() {
		return instruction;
	}

	public void setInstruction(String instruction) {
		this.instruction = instruction;
	}

	public String getImgUrl() {
		return imgUrl;
	}

	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	@Override
	public String toString() {
		return "RecipeDTO [recipeCode=" + recipeCode + ", categoryId=" + categoryId + ", subCategoryCode=" + subCategoryCode + ", name=" + name + ", price=" + price + ", instruction=" + instruction + ", imgUrl=" + imgUrl + ", isActive=" + isActive + "]";
	}
}

