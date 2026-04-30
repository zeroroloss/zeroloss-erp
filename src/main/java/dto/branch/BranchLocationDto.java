package dto.branch;

public class BranchLocationDto {
    private double lat;
    private double lng;

    public BranchLocationDto() {
    }

    public BranchLocationDto(double lat, double lng) {
        this.lat = lat;
        this.lng = lng;
    }

    // Getters
    public double getLat() { return lat; }
    public double getLng() { return lng; }

    // Setters
    public void setLat(double lat) { this.lat = lat; }
    public void setLng(double lng) { this.lng = lng; }
}
