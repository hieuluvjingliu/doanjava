<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                <img src="${pageContext.request.contextPath}/${product.image}" alt="${product.name}">
            </div>
        </div>

        <!-- Thông Tin & Mua Hàng -->
        <div class="col-md-6">
            <div class="product-info">
                <h1>${product.name}</h1>
                <div class="product-price">${product.basePrice} VNĐ</div>
                
                <form action="gio-hang" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="${product.id}">
                    
                    <div class="variant-box">
                        <label class="fw-bold mb-2">Chọn Phân Loại Hàng:</label>
                        <c:if test="${empty variants}">
                            <p class="text-danger">Sản phẩm này hiện chưa có phân loại (hết hàng).</p>
                        </c:if>
                        <c:if test="${not empty variants}">
                            <select name="variantId" class="form-select mb-3" required>
                                <option value="">-- Chọn Size / Màu --</option>
                                <c:forEach var="v" items="${variants}">
                                    <option value="${v.id}">
                                        Màu ID: ${v.colorId} - Size ID: ${v.sizeId} (Kho: ${v.quantity})
                                    </option>
                                </c:forEach>
                            </select>
                            
                            <label class="fw-bold mb-2">Số lượng:</label>
                            <input type="number" name="quantity" class="form-control mb-3" value="1" min="1" max="50" style="width: 100px;">
                            
                            <button type="submit" class="add-to-cart-btn">THÊM VÀO GIỎ HÀNG</button>
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

<jsp:include page="footer.jsp" />
