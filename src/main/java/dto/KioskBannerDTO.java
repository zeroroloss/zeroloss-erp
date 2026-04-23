package dto;

import java.time.LocalDate;
import java.time.LocalTime;

public class KioskBannerDTO {
	private Integer bannerId;
	private Integer kioskId;
	private String mediaUrl;
	private Boolean isActive;

	public KioskBannerDTO() {
		super();
	}

	public KioskBannerDTO(Integer bannerId, Integer kioskId, String mediaUrl, Boolean isActive) {
		super();
		this.bannerId = bannerId;
		this.kioskId = kioskId;
		this.mediaUrl = mediaUrl;
		this.isActive = isActive;
	}

	public Integer getBannerId() {
		return bannerId;
	}

	public void setBannerId(Integer bannerId) {
		this.bannerId = bannerId;
	}

	public Integer getKioskId() {
		return kioskId;
	}

	public void setKioskId(Integer kioskId) {
		this.kioskId = kioskId;
	}

	public String getMediaUrl() {
		return mediaUrl;
	}

	public void setMediaUrl(String mediaUrl) {
		this.mediaUrl = mediaUrl;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	@Override
	public String toString() {
		return "KioskBannerDTO [bannerId=" + bannerId + ", kioskId=" + kioskId + ", mediaUrl=" + mediaUrl + ", isActive=" + isActive + "]";
	}
}

