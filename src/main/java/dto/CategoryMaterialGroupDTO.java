package dto;

public class CategoryMaterialGroupDTO {
	private Integer caMaId;
	private Integer categoryId;
	private Integer materialGroupId;

	public CategoryMaterialGroupDTO() {
		super();
	}

	public CategoryMaterialGroupDTO(Integer caMaId, Integer categoryId, Integer materialGroupId) {
		super();
		this.caMaId = caMaId;
		this.categoryId = categoryId;
		this.materialGroupId = materialGroupId;
	}

	public Integer getCaMaId() {
		return caMaId;
	}

	public void setCaMaId(Integer caMaId) {
		this.caMaId = caMaId;
	}

	public Integer getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(Integer categoryId) {
		this.categoryId = categoryId;
	}

	public Integer getMaterialGroupId() {
		return materialGroupId;
	}

	public void setMaterialGroupId(Integer materialGroupId) {
		this.materialGroupId = materialGroupId;
	}

	@Override
	public String toString() {
		return "CategoryMaterialGroupDTO [caMaId=" + caMaId + ", categoryId=" + categoryId + ", materialGroupId=" + materialGroupId + "]";
	}
}

