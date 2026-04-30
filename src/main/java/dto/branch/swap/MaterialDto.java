package dto.branch.swap;

public class MaterialDto {
    private String materialCode;
    private String materialName;

    public MaterialDto() {}

    public MaterialDto(String materialCode, String materialName) {
        this.materialCode = materialCode;
        this.materialName = materialName;
    }

    public String getMaterialCode() {
        return materialCode;
    }

    public void setMaterialCode(String materialCode) {
        this.materialCode = materialCode;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }
}
