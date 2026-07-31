package model;

import java.math.BigDecimal;

public class HoaDonChiTiet {
    private int id;
    private int invoiceId;
    private int variantId;
    private String productName;
    private String colorName;
    private String sizeName;
    private String productImage;
    private BigDecimal priceAtPurchase;
    private int quantity;
    private BigDecimal lineTotal;

    public HoaDonChiTiet() {}

    public HoaDonChiTiet(int invoiceId, int variantId, String productName, String colorName,
                         String sizeName, String productImage, BigDecimal priceAtPurchase, int quantity) {
        this.invoiceId = invoiceId;
        this.variantId = variantId;
        this.productName = productName;
        this.colorName = colorName;
        this.sizeName = sizeName;
        this.productImage = productImage;
        this.priceAtPurchase = priceAtPurchase;
        this.quantity = quantity;
        this.lineTotal = priceAtPurchase.multiply(BigDecimal.valueOf(quantity));
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }

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

    public BigDecimal getPriceAtPurchase() { return priceAtPurchase; }
    public void setPriceAtPurchase(BigDecimal priceAtPurchase) { this.priceAtPurchase = priceAtPurchase; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getLineTotal() { return lineTotal; }
    public void setLineTotal(BigDecimal lineTotal) { this.lineTotal = lineTotal; }
}
