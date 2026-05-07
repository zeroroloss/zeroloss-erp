package dto.hq.hr;

public class GradeDTO {
	private String gradeCode;
	private String gradeName;
	private Integer gradeOrder;

	public GradeDTO() {	}

	public GradeDTO(String gradeCode, String gradeName, Integer gradeOrder) {
		super();
		this.gradeCode = gradeCode;
		this.gradeName = gradeName;
		this.gradeOrder = gradeOrder;
	}

	public String getGradeCode() {
		return gradeCode;
	}

	public void setGradeCode(String gradeCode) {
		this.gradeCode = gradeCode;
	}

	public String getGradeName() {
		return gradeName;
	}

	public void setGradeName(String gradeName) {
		this.gradeName = gradeName;
	}

	public Integer getGradeOrder() {
		return gradeOrder;
	}

	public void setGradeOrder(Integer gradeOrder) {
		this.gradeOrder = gradeOrder;
	}

	@Override
	public String toString() {
		return "GradeDTO [gradeCode=" + gradeCode + ", gradeName=" + gradeName + ", gradeOrder=" + gradeOrder + "]";
	}
}

