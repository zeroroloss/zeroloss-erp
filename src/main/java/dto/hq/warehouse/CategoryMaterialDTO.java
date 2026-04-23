package dto.hq.warehouse;


public class CategoryMaterialDTO {
    private String groupName;
    private String materialName;
    
	public CategoryMaterialDTO(String groupName, String materialName) {
		super();
		this.groupName = groupName;
		this.materialName = materialName;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}
	
}
