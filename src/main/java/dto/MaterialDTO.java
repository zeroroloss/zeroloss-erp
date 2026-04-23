package dto;

public class MaterialDTO {
    private String materialCode;
    private Integer materialGroupId;
    private String materialName;
    private Integer materialPrice; // 변경: price -> materialPrice
    private Integer price; // 기존 price 필드 유지 (다른 용도로 사용될 수 있으므로)
    private String unit;

    // 기본 생성자
    public MaterialDTO() {
        super();
    }

    // 모든 필드를 포함하는 생성자
    public MaterialDTO(String materialCode, Integer materialGroupId, String materialName, Integer materialPrice, Integer price, String unit) {
        super();
        this.materialCode = materialCode;
        this.materialGroupId = materialGroupId;
        this.materialName = materialName;
        this.materialPrice = materialPrice;
        this.price = price;
        this.unit = unit;
    }

    // Getters and Setters
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

    public Integer getMaterialPrice() {
        return materialPrice;
    }

    public void setMaterialPrice(Integer materialPrice) {
        this.materialPrice = materialPrice;
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
        return "MaterialDTO [materialCode=" + materialCode + ", materialGroupId=" + materialGroupId + ", materialName=" + materialName + ", materialPrice=" + materialPrice + ", price=" + price + ", unit=" + unit + "]";
    }
}
