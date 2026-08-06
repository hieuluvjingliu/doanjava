<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="productImg">
    <my:safeImage value="${product.image}" width="600" height="600"/>
</c:set>
<jsp:include page="header.jsp" />

<style>
    .product-detail-container { max-width: 1200px; margin: 50px auto; padding: 20px; font-family: 'Inter', sans-serif;}
    .product-image img { width: 100%; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
    .product-info h1 { font-size: 28px; font-weight: 700; color: #111; margin-bottom: 15px;}
    .product-price { font-size: 24px; color: #d9534f; font-weight: bold; margin-bottom: 20px;}
    .variant-box { border: 1px solid #ddd; padding: 15px; border-radius: 8px; margin-bottom: 20px; background: #f9f9f9;}
    .add-to-cart-btn { background-color: #111; color: #fff; border: none; padding: 15px 30px; font-size: 16px; font-weight: bold; width: 100%; border-radius: 5px; cursor: pointer; transition: 0.3s;}
    .add-to-cart-btn:hover { background-color: #333; }
    .desc-box { margin-top: 30px; line-height: 1.6; color: #555; }
</style>

<div class="product-detail-container">
    <div class="row">
        <!-- Ảnh Sản Phẩm -->
        <div class="col-md-6">
            <div class="product-image">
                <img src="${productImg}" alt="${product.name}">
            </div>
        </div>

        <!-- Thông Tin & Mua Hàng -->
        <div class="col-md-6">
            <div class="product-info">
                <h1>${product.name}</h1>
                <div class="product-price">
                    <c:choose>
                        <c:when test="${not empty selectedVariant}">
                            <fmt:formatNumber value="${selectedVariant.price}" pattern="#,### VNĐ" />
                        </c:when>
                        <c:otherwise>
                            <fmt:formatNumber value="${product.basePrice}" pattern="#,### VNĐ" />
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <form action="${pageContext.request.contextPath}/gio-hang" method="post" id="addToCartForm">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="${product.id}">
                    <input type="hidden" name="productName" value="${product.name}">
                    <input type="hidden" name="productImage" value="${productImg}">
                    <input type="hidden" name="price" id="selectedPrice" value="${product.basePrice}">
                    <input type="hidden" name="colorName" id="selectedColorName" value="">
                    <input type="hidden" name="sizeName" id="selectedSizeName" value="">
                    
                    <div class="variant-box">
                        <label class="fw-bold mb-2">Chọn Phân Loại Hàng:</label>
                        <c:if test="${empty variants}">
                            <p class="text-danger">Sản phẩm này hiện chưa có phân loại (hết hàng).</p>
                        </c:if>
                        <c:if test="${not empty variants}">
                            <select name="variantId" id="variantSelect" class="form-select mb-3" required onchange="updatePrice()">
                                <option value="" data-price="${product.basePrice}">-- Chọn Size / Màu --</option>
                                <c:forEach var="v" items="${variants}">
                                    <c:set var="colorName" value="N/A" />
                                    <c:forEach var="c" items="${listMauSac}">
                                        <c:if test="${c.id == v.colorId}"><c:set var="colorName" value="${c.name}" /></c:if>
                                    </c:forEach>
                                    <c:set var="sizeName" value="N/A" />
                                    <c:forEach var="s" items="${listKichThuoc}">
                                        <c:if test="${s.id == v.sizeId}"><c:set var="sizeName" value="${s.name}" /></c:if>
                                    </c:forEach>
                                    <option value="${v.id}" data-price="${v.price != null ? v.price : product.basePrice}" data-quantity="${v.quantity}" data-image="${v.image != null ? v.image : productImg}" data-color="${colorName}" data-size="${sizeName}">
                                        Màu ${colorName} - Size ${sizeName} (Kho: ${v.quantity})
                                    </option>
                                </c:forEach>
                            </select>
                            
                            <label class="fw-bold mb-2">Số lượng:</label>
                            <input type="number" name="quantity" class="form-control mb-3" value="1" min="1" max="50" style="width: 100px;" id="quantityInput">
                            
                            <button type="submit" class="add-to-cart-btn" id="addToCartBtn">THÊM VÀO GIỎ HÀNG</button>
                        </c:if>
                    </div>
                </form>
                
                <div class="desc-box">
                    <h4 class="fw-bold">Mô tả sản phẩm:</h4>
                    <p>${product.description}</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function updatePrice() {
    var select = document.getElementById('variantSelect');
    var selectedOption = select.options[select.selectedIndex];
    var price = selectedOption.getAttribute('data-price');
    document.getElementById('selectedPrice').value = price;
    
    var image = selectedOption.getAttribute('data-image');
    if (image) {
        document.querySelector('input[name="productImage"]').value = image;
    }
    
    var colorName = selectedOption.getAttribute('data-color');
    var sizeName = selectedOption.getAttribute('data-size');
    document.getElementById('selectedColorName').value = colorName || "";
    document.getElementById('selectedSizeName').value = sizeName || "";
}
</script>

<jsp:include page="footer.jsp" />
