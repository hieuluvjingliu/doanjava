package model;

public class KichThuoc {
    private int id;
    private String name;
    private int sortOrder;
    private String status;

    public KichThuoc() {
    }

    public KichThuoc(int id, String name, int sortOrder, String status) {
        this.id = id;
        this.name = name;
        this.sortOrder = sortOrder;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
