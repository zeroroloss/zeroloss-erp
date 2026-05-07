package dto;

import java.util.Objects;

public class HqBranchSearchDTO {
    private String id;
    private String name;
    private String region;
    private String regionCode; // regionCode 필드 추가
    private String address;
    private String phone;
    private String status;
    private String managerName;
    private String managerPhone;
    private String managerEmail;
    private int employeeCount;

    public HqBranchSearchDTO() {}

    // 모든 필드를 포함하는 생성자
    public HqBranchSearchDTO(String id, String name, String region, String regionCode, String address, String phone, String status, String managerName, String managerPhone, String managerEmail, int employeeCount) {
        this.id = id;
        this.name = name;
        this.region = region;
        this.regionCode = regionCode;
        this.address = address;
        this.phone = phone;
        this.status = status;
        this.managerName = managerName;
        this.managerPhone = managerPhone;
        this.managerEmail = managerEmail;
        this.employeeCount = employeeCount;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getRegion() { return region; }
    public void setRegion(String region) { this.region = region; }
    public String getRegionCode() { return regionCode; } // regionCode Getter/Setter
    public void setRegionCode(String regionCode) { this.regionCode = regionCode; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getManagerName() { return managerName; }
    public void setManagerName(String managerName) { this.managerName = managerName; }
    public String getManagerPhone() { return managerPhone; }
    public void setManagerPhone(String managerPhone) { this.managerPhone = managerPhone; }
    public String getManagerEmail() { return managerEmail; }
    public void setManagerEmail(String managerEmail) { this.managerEmail = managerEmail; }
    public int getEmployeeCount() { return employeeCount; }
    public void setEmployeeCount(int employeeCount) { this.employeeCount = employeeCount; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        HqBranchSearchDTO that = (HqBranchSearchDTO) o;
        return employeeCount == that.employeeCount && Objects.equals(id, that.id) && Objects.equals(name, that.name) && Objects.equals(region, that.region) && Objects.equals(regionCode, that.regionCode) && Objects.equals(address, that.address) && Objects.equals(phone, that.phone) && Objects.equals(status, that.status) && Objects.equals(managerName, that.managerName) && Objects.equals(managerPhone, that.managerPhone) && Objects.equals(managerEmail, that.managerEmail);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, name, region, regionCode, address, phone, status, managerName, managerPhone, managerEmail, employeeCount);
    }

    @Override
    public String toString() {
        return "HqBranchSearchDTO{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", region='" + region + '\'' +
                ", regionCode='" + regionCode + '\'' +
                ", address='" + address + '\'' +
                ", phone='" + phone + '\'' +
                ", status='" + status + '\'' +
                ", managerName='" + managerName + '\'' +
                ", managerPhone='" + managerPhone + '\'' +
                ", managerEmail='" + managerEmail + '\'' +
                ", employeeCount=" + employeeCount +
                '}';
    }
}
