package dto.hq.sales;

public class SubCategoryDTO {
    private String subCategoryCode;
    private String name;

    public SubCategoryDTO() {}

    public SubCategoryDTO(String subCategoryCode, String name) {
        this.subCategoryCode = subCategoryCode;
        this.name = name;
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

    @Override
    public String toString() {
        return "SubCategoryDTO{" +
                "subCategoryCode='" + subCategoryCode + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
