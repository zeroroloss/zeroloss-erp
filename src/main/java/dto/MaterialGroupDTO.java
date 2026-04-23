package dto;

public class MaterialGroupDTO {
	private Integer materialGroupId;
	private String groupName;
	private Integer groupMin;
	private Integer groupMax;

	public MaterialGroupDTO() {
		super();
	}

	public MaterialGroupDTO(Integer materialGroupId, String groupName, Integer groupMin, Integer groupMax) {
		super();
		this.materialGroupId = materialGroupId;
		this.groupName = groupName;
		this.groupMin = groupMin;
		this.groupMax = groupMax;
	}

	public Integer getMaterialGroupId() {
		return materialGroupId;
	}

	public void setMaterialGroupId(Integer materialGroupId) {
		this.materialGroupId = materialGroupId;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public Integer getGroupMin() {
		return groupMin;
	}

	public void setGroupMin(Integer groupMin) {
		this.groupMin = groupMin;
	}

	public Integer getGroupMax() {
		return groupMax;
	}

	public void setGroupMax(Integer groupMax) {
		this.groupMax = groupMax;
	}

	@Override
	public String toString() {
		return "MaterialGroupDTO [materialGroupId=" + materialGroupId + ", groupName=" + groupName + ", groupMin=" + groupMin + ", groupMax=" + groupMax + "]";
	}
}

