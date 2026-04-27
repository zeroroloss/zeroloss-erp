package dto.hq;

public class SupplierDTO {
	private Integer supplierId;
	private String supplierName;
	
	public Integer getSupplierId() {
		return supplierId;
	}
	public void setSupplierId(Integer supplierId) {
		this.supplierId = supplierId;
	}
	public String getSupplierName() {
		return supplierName;
	}
	public void setSupplierName(String supplierName) {
		this.supplierName = supplierName;
	}
	
	@Override
	public String toString() {
		return "SupplierDTO [supplierId=" + supplierId + ", supplierName=" + supplierName + "]";
	}

}
