package dto;

import java.time.LocalDateTime;

public class MainCategoryDTO {
	private Integer categoryId;
	private String name;
	private Boolean isActive;
	private LocalDateTime createdAt;

	public MainCategoryDTO() {
		super();
	}

	public MainCategoryDTO(Integer categoryId, String name, Boolean isActive, LocalDateTime createdAt) {
		super();
		this.categoryId = categoryId;
		this.name = name;
		this.isActive = isActive;
		this.createdAt = createdAt;
	}

	public Integer getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(Integer categoryId) {
		this.categoryId = categoryId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	@Override
	public String toString() {
		return "MainCategoryDTO [categoryId=" + categoryId + ", name=" + name + ", isActive=" + isActive + ", createdAt=" + createdAt + "]";
	}
}

