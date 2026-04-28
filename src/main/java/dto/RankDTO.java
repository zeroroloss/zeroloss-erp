package dto;

public class RankDTO implements java.io.Serializable {
    private String name;
    private String meta;
    private double value;

    public RankDTO() {}

    public RankDTO(String name, String meta, double value) {
        this.name = name;
        this.meta = meta;
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMeta() {
        return meta;
    }

    public void setMeta(String meta) {
        this.meta = meta;
    }

    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }

    @Override
    public String toString() {
        return "RankDTO{" +
                "name='" + name + '\'' +
                ", meta='" + meta + '\'' +
                ", value=" + value +
                '}';
    }
}
