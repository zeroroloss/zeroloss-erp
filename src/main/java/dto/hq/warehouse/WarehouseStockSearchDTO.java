package dto.hq.warehouse;

public class WarehouseStockSearchDTO {
	private String categoryName;
	private String itemName;
	private String keyword; // 검색어
	
	public WarehouseStockSearchDTO(String categoryName, String itemName, String keyword) {
		super();
		this.categoryName = categoryName;
		this.itemName = itemName;
		this.keyword = keyword;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

}
