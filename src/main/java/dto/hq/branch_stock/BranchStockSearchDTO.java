package dto.hq.branch_stock;

public class BranchStockSearchDTO {
	private String branchCode;
	private Integer materialGroupId;
	private String materialCode;
	private String keyword;
	private String tab;
	
	// 추가
    private Integer expireWithinDays; // N일 이내 (ex: 3)
    private String stockStatus;
	
	public BranchStockSearchDTO() { }

	public BranchStockSearchDTO(String branchCode, Integer materialGroupId, String materialCode, String keyword,
			String tab) {
		super();
		this.branchCode = branchCode;
		this.materialGroupId = materialGroupId;
		this.materialCode = materialCode;
		this.keyword = keyword;
		this.tab = tab;
	}

	public String getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(String branchCode) {
		this.branchCode = branchCode;
	}

	public Integer getMaterialGroupId() {
		return materialGroupId;
	}

	public void setMaterialGroupId(Integer materialGroupId) {
		this.materialGroupId = materialGroupId;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getTab() {
		return tab;
	}

	public void setTab(String tab) {
		this.tab = tab;
	}
	
	// getter/setter
    public Integer getExpireWithinDays() {
        return expireWithinDays;
    }

    public void setExpireWithinDays(Integer expireWithinDays) {
        this.expireWithinDays = expireWithinDays;
    }
    public String getStockStatus() {
        return stockStatus;
    }

    public void setStockStatus(String stockStatus) {
        this.stockStatus = stockStatus;
    }
}
