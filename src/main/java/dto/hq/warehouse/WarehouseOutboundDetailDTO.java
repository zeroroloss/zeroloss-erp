package dto.hq.warehouse;

import java.util.List;

public class WarehouseOutboundDetailDTO {
    private Integer hqOutboundNo;
    private String poNo;
    private Integer branchCode;
    private String branchName;
    private String status; 	// 출고대기, 준비중, 출고완료
    private String driverName;
    private String plateNumber;
    private String outboundAt;

    private List<WarehouseOutboundItemDTO> items;

	@Override
	public String toString() {
		return "WarehouseOutboundDetailDTO [hqOutboundNo=" + hqOutboundNo + ", poNo=" + poNo + ", branchCode="
				+ branchCode + ", branchName=" + branchName + ", status=" + status + ", driverName=" + driverName
				+ ", plateNumber=" + plateNumber + ", outboundAt=" + outboundAt + ", items=" + items + "]";
	}

	public Integer getHqOutboundNo() {
		return hqOutboundNo;
	}

	public void setHqOutboundNo(Integer hqOutboundNo) {
		this.hqOutboundNo = hqOutboundNo;
	}

	public String getPoNo() {
		return poNo;
	}

	public void setPoNo(String poNo) {
		this.poNo = poNo;
	}

	public Integer getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(Integer branchCode) {
		this.branchCode = branchCode;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDriverName() {
		return driverName;
	}

	public void setDriverName(String driverName) {
		this.driverName = driverName;
	}

	public String getPlateNumber() {
		return plateNumber;
	}

	public void setPlateNumber(String plateNumber) {
		this.plateNumber = plateNumber;
	}

	public String getOutboundAt() {
		return outboundAt;
	}

	public void setOutboundAt(String outboundAt) {
		this.outboundAt = outboundAt;
	}

	public List<WarehouseOutboundItemDTO> getItems() {
		return items;
	}

	public void setItems(List<WarehouseOutboundItemDTO> items) {
		this.items = items;
	}

}
