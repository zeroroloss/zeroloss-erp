package dto;

public class SubCategoryDTO {
	private String subCategoryCode;
	private Integer mainCategoryId;
	private String name;

	public SubCategoryDTO() {
		super();
	}

	public SubCategoryDTO(String subCategoryCode, Integer mainCategoryId, String name) {
		super();
		this.subCategoryCode = subCategoryCode;
		this.mainCategoryId = mainCategoryId;
		this.name = name;
	}

	public String getSubCategoryCode() {
		return subCategoryCode;
	}

	public void setSubCategoryCode(String subCategoryCode) {
		this.subCategoryCode = subCategoryCode;
	}

	public Integer getMainCategoryId() {
		return mainCategoryId;
	}

	public void setMainCategoryId(Integer mainCategoryId) {
		this.mainCategoryId = mainCategoryId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "SubCategoryDTO [subCategoryCode=" + subCategoryCode + ", mainCategoryId=" + mainCategoryId + ", name=" + name + "]";
	}
}

