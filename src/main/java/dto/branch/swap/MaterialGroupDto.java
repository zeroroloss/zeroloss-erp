package dto.branch.swap;

public class MaterialGroupDto {
    private int materialGroupId;
    private String groupName;

    public MaterialGroupDto() {}

    public MaterialGroupDto(int materialGroupId, String groupName) {
        this.materialGroupId = materialGroupId;
        this.groupName = groupName;
    }

    public int getMaterialGroupId() {
        return materialGroupId;
    }

    public void setMaterialGroupId(int materialGroupId) {
        this.materialGroupId = materialGroupId;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }
}
