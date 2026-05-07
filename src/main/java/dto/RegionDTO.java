package dto;

public class RegionDTO {
	private String regionCode;
	private String name;

	public RegionDTO() {}

	public RegionDTO(String regionCode, String name) {
		super();
		this.regionCode = regionCode;
		this.name = name;
	}

	public String getRegionCode() {
		return regionCode;
	}

	public void setRegionCode(String regionCode) {
		this.regionCode = regionCode;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "RegionDTO [regionCode=" + regionCode + ", name=" + name + "]";
	}
}

