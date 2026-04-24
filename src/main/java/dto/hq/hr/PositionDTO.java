package dto.hq.hr;

public class PositionDTO {
	private String positionCode;
	private String positionName;
	private Integer positionLevel;

	public PositionDTO() {
		super();
	}

	public PositionDTO(String positionCode, String positionName, Integer positionLevel) {
		super();
		this.positionCode = positionCode;
		this.positionName = positionName;
		this.positionLevel = positionLevel;
	}

	public String getPositionCode() {
		return positionCode;
	}

	public void setPositionCode(String positionCode) {
		this.positionCode = positionCode;
	}

	public String getPositionName() {
		return positionName;
	}

	public void setPositionName(String positionName) {
		this.positionName = positionName;
	}

	public Integer getPositionLevel() {
		return positionLevel;
	}

	public void setPositionLevel(Integer positionLevel) {
		this.positionLevel = positionLevel;
	}

	@Override
	public String toString() {
		return "PositionDTO [positionCode=" + positionCode + ", positionName=" + positionName + ", positionLevel=" + positionLevel + "]";
	}
}

