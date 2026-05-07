package dto;

import java.math.BigDecimal;

public class RecipeDetailDTO {
	private Integer recipeDetailId;
	private String recipeCode;
	private String materialCode;
	private BigDecimal requiredQty;

	public RecipeDetailDTO() {}

	public RecipeDetailDTO(Integer recipeDetailId, String recipeCode, String materialCode, BigDecimal requiredQty) {
		super();
		this.recipeDetailId = recipeDetailId;
		this.recipeCode = recipeCode;
		this.materialCode = materialCode;
		this.requiredQty = requiredQty;
	}

	public Integer getRecipeDetailId() {
		return recipeDetailId;
	}

	public void setRecipeDetailId(Integer recipeDetailId) {
		this.recipeDetailId = recipeDetailId;
	}

	public String getRecipeCode() {
		return recipeCode;
	}

	public void setRecipeCode(String recipeCode) {
		this.recipeCode = recipeCode;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	public BigDecimal getRequiredQty() {
		return requiredQty;
	}

	public void setRequiredQty(BigDecimal requiredQty) {
		this.requiredQty = requiredQty;
	}

	@Override
	public String toString() {
		return "RecipeDetailDTO [recipeDetailId=" + recipeDetailId + ", recipeCode=" + recipeCode + ", materialCode=" + materialCode + ", requiredQty=" + requiredQty + "]";
	}
}

