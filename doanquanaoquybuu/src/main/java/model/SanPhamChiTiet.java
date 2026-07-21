package model;

public class SanPhamChiTiet {
    private int id;
    private int productId;
    private int colorId;
    private int sizeId;
    private String sku;
    private Double price; // có thể null
    private int quantity;
    private String image;
    private String status;

    public SanPhamChiTiet() {
    }

    public SanPhamChiTiet(int id, int productId, int colorId, int sizeId, String sku, Double price, int quantity, String image, String status) {
        this.id = id;
        this.productId = productId;
        this.colorId = colorId;
        this.sizeId = sizeId;
        this.sku = sku;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getColorId() {
        return colorId;
    }

    public void setColorId(int colorId) {
        this.colorId = colorId;
    }

    public int getSizeId() {
        return sizeId;
    }

    public void setSizeId(int sizeId) {
        this.sizeId = sizeId;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
