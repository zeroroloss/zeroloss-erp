package dto.hq.warehouse;

/**
 * 유통기한 조회 검색 조건 DTO
 */
public class ExpirySearchDTO {
    private String category;      // 카테고리 (선택)
    private String itemName;      // 품목명 (선택)
    private String search;        // 검색어 (선택)

    public ExpirySearchDTO() {
        super();
    }

    public ExpirySearchDTO(String category, String itemName, String search) {
        this.category = category;
        this.itemName = itemName;
        this.search = search;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getSearch() {
        return search;
    }

    public void setSearch(String search) {
        this.search = search;
    }

    @Override
    public String toString() {
        return "ExpirySearchDTO{" +
                "category='" + category + '\'' +
                ", itemName='" + itemName + '\'' +
                ", search='" + search + '\'' +
                '}';
    }
}
