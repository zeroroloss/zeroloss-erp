package dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class BranchStockDTO {
	private Integer branchStockId;
	private String branchStockCode;
	private Integer branchCode;
	private String materialCode;
	private LocalDate expireDate;
	private LocalDateTime receivedAt;
	private BigDecimal currentQty;
	
	//조회에 쓰기 위한 조인 필드
	private String groupName;
	private String materialName;
	private BigDecimal safeStockQty;
	private String unit;


	public BranchStockDTO() {}


	public BranchStockDTO(Integer branchStockId, String branchStockCode, Integer branchCode, String materialCode,
			LocalDate expireDate, LocalDateTime receivedAt, BigDecimal currentQty, String groupName,
			String materialName, BigDecimal safeStockQty, String unit) {
		super();
		this.branchStockId = branchStockId;
		this.branchStockCode = branchStockCode;
		this.branchCode = branchCode;
		this.materialCode = materialCode;
		this.expireDate = expireDate;
		this.receivedAt = receivedAt;
		this.currentQty = currentQty;
		this.groupName = groupName;
		this.materialName = materialName;
		this.safeStockQty = safeStockQty;
		this.unit = unit;
	}


	public Integer getBranchStockId() {
		return branchStockId;
	}


	public void setBranchStockId(Integer branchStockId) {
		this.branchStockId = branchStockId;
	}


	public String getBranchStockCode() {
		return branchStockCode;
	}


	public void setBranchStockCode(String branchStockCode) {
		this.branchStockCode = branchStockCode;
	}


	public Integer getBranchCode() {
		return branchCode;
	}


	public void setBranchCode(Integer branchCode) {
		this.branchCode = branchCode;
	}


	public String getMaterialCode() {
		return materialCode;
	}


	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}


	public LocalDate getExpireDate() {
		return expireDate;
	}


	public void setExpireDate(LocalDate expireDate) {
		this.expireDate = expireDate;
	}


	public LocalDateTime getReceivedAt() {
		return receivedAt;
	}


	public void setReceivedAt(LocalDateTime receivedAt) {
		this.receivedAt = receivedAt;
	}


	public BigDecimal getCurrentQty() {
		return currentQty;
	}


	public void setCurrentQty(BigDecimal currentQty) {
		this.currentQty = currentQty;
	}


	public String getGroupName() {
		return groupName;
	}


	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}


	public String getMaterialName() {
		return materialName;
	}


	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}


	public BigDecimal getSafeStockQty() {
		return safeStockQty;
	}


	public void setSafeStockQty(BigDecimal safeStockQty) {
		this.safeStockQty = safeStockQty;
	}


	public String getUnit() {
		return unit;
	}


	public void setUnit(String unit) {
		this.unit = unit;
	}

}

