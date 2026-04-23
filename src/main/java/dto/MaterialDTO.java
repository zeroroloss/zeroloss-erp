package dto;

public class MaterialDTO {
	private String materialCode;
	private Integer materialGroupId;
	private String materialName;
	private Integer price;
	private String unit;

	public MaterialDTO() {
		super();
	}

	public MaterialDTO(String materialCode, Integer materialGroupId, String materialName, Integer price, String unit) {
		super();
		this.materialCode = materialCode;
		this.materialGroupId = materialGroupId;
		this.materialName = materialName;
		this.price = price;
		this.unit = unit;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	public Integer getMaterialGroupId() {
		return materialGroupId;
	}

	public void setMaterialGroupId(Integer materialGroupId) {
		this.materialGroupId = materialGroupId;
	}

	public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}

	public Integer getPrice() {
		return price;
	}

	public void setPrice(Integer price) {
		this.price = price;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	@Override
	public String toString() {
		return "MaterialDTO [materialCode=" + materialCode + ", materialGroupId=" + materialGroupId + ", materialName=" + materialName + ", price=" + price + ", unit=" + unit + "]";
	}
}

