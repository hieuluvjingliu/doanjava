package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int productId;
    private int variantId;
    private String productName;
    private String colorName;
    private String sizeName;
    private String productImage;
    private BigDecimal price;
    private int quantity;

    public CartItem() {}

    public CartItem(int productId, int variantId, String productName, String colorName, String sizeName, String productImage, BigDecimal price, int quantity) {
        this.productId = productId;
        this.variantId = variantId;
        this.productName = productName;
        this.colorName = colorName;
        this.sizeName = sizeName;
        this.productImage = productImage;
        this.price = price;
        this.quantity = quantity;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getVariantId() { return variantId; }
    public void setVariantId(int variantId) { this.variantId = variantId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getColorName() { return colorName; }
    public void setColorName(String colorName) { this.colorName = colorName; }

    public String getSizeName() { return sizeName; }
    public void setSizeName(String sizeName) { this.sizeName = sizeName; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getTotal() {
        return price.multiply(BigDecimal.valueOf(quantity));
    }
}
