<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<jsp:include page="header.jsp" />

<style>
    .cart-page { max-width: 1000px; margin: 40px auto; padding: 20px; }
    .cart-title { font-size: 28px; font-weight: bold; text-align: center; margin-bottom: 30px; letter-spacing: 1px;}
    .cart-empty { text-align: center; padding: 60px 20px; }
    .cart-empty i { font-size: 80px; color: #ccc; margin-bottom: 20px; }
    .cart-table { width: 100%; border-collapse: collapse; }
    .cart-table th { text-align: left; padding: 15px; border-bottom: 2px solid #ddd; color: #333; font-weight: 600; }
    .cart-table td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; }
    .cart-table .product-img { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; }
    .cart-table .product-name { font-weight: 500; color: #333; }
    .cart-table .product-price { color: #e74c3c; font-weight: 600; }
    .qty-control { display: flex; align-items: center; gap: 8px; }
    .qty-btn { width: 32px; height: 32px; border: 1px solid #ddd; background: #fff; cursor: pointer; font-size: 16px; }
    .qty-btn:hover { background: #f5f5f5; }
    .qty-value { min-width: 30px; text-align: center; font-weight: 600; }
    .btn-remove { color: #e74c3c; text-decoration: none; font-size: 14px; }
    .btn-remove:hover { text-decoration: underline; }
    .cart-summary { margin-top: 30px; padding: 20px; background: #f9f9f9; border-radius: 10px; }
    .cart-total { font-size: 24px; font-weight: bold; color: #333; margin-bottom: 20px; }
    .cart-total span { color: #e74c3c; }
    .btn-checkout { background-color: #000; color: #fff; border: none; padding: 15px 40px; font-size: 16px; font-weight: bold; border-radius: 5px; transition: 0.3s; text-decoration: none; display: inline-block; }
    .btn-checkout:hover { background-color: #333; color: white; }
    .btn-continue { background-color: #fff; color: #333; border: 1px solid #333; padding: 15px 30px; font-size: 16px; border-radius: 5px; text-decoration: none; display: inline-block; }
    .btn-continue:hover { background: #f5f5f5; }
    .cart-actions { display: flex; justify-content: space-between; align-items: center; margin-top: 20px; }
    .btn-clear { color: #999; border: none; background: none; cursor: pointer; font-size: 14px; }
    .btn-clear:hover { color: #e74c3c; }
</style>

<div class="container">
    <div class="cart-page">
        <h2 class="cart-title"><i class="fa-solid fa-cart-shopping"></i> GIỎ HÀNG CỦA BẠN</h2>

        <c:if test="${empty cartItems}">
            <div class="cart-empty">
                <i class="fa-solid fa-cart-arrow-down"></i>
                <h3>Giỏ hàng trống</h3>
                <p class="text-muted mb-4">Hãy thêm sản phẩm vào giỏ hàng của bạn</p>
                <a href="${pageContext.request.contextPath}/trang-chu" class="btn-checkout">BẮT ĐẦU MUA SẮM</a>
            </div>
        </c:if>

        <c:if test="${not empty cartItems}">
            <c:if test="${param.msg == 'added'}">
                <div class="alert alert-success mb-4">Thêm sản phẩm vào giỏ hàng thành công!</div>
            </c:if>

            <table class="cart-table">
                <thead>
                    <tr>
                        <th>ẢNH</th>
                        <th>SẢN PHẨM</th>
                        <th>GIÁ</th>
                        <th>SỐ LƯỢNG</th>
                        <th>TẠM TÍNH</th>
                        <th>XÓA</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <td>
                                <img src="<my:safeImage value='${item.productImage}' width='80' height='80'/>" alt="${item.productName}" class="product-img">
                            </td>
                            <td class="product-name">
                                ${item.productName}<br>
                                <small class="text-muted">Phân loại: ${item.colorName} - ${item.sizeName}</small>
                            </td>
                            <td class="product-price">
                                <fmt:formatNumber value="${item.price}" pattern="#,### VNĐ" />
                            </td>
                            <td>
                                <div class="qty-control">
                                    <form action="${pageContext.request.contextPath}/gio-hang" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="variantId" value="${item.variantId}">
                                        <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                        <button type="submit" class="qty-btn" ${item.quantity <= 1 ? 'disabled' : ''}>-</button>
                                    </form>
                                    <span class="qty-value">${item.quantity}</span>
                                    <form action="${pageContext.request.contextPath}/gio-hang" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="variantId" value="${item.variantId}">
                                        <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                        <button type="submit" class="qty-btn">+</button>
                                    </form>
                                </div>
                            </td>
                            <td class="product-price">
                                <fmt:formatNumber value="${item.total}" pattern="#,### VNĐ" />
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/gio-hang" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="variantId" value="${item.variantId}">
                                    <button type="submit" class="btn-remove"><i class="fa-solid fa-trash"></i> Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="cart-summary">
                <div class="cart-total text-end">
                    TỔNG CỘNG: <span><fmt:formatNumber value="${cartTotal}" pattern="#,### VNĐ" /></span>
                </div>
                <div class="cart-actions">
                    <form action="${pageContext.request.contextPath}/gio-hang" method="post">
                        <input type="hidden" name="action" value="clear">
                        <button type="submit" class="btn-clear"><i class="fa-solid fa-trash-alt"></i> Xóa toàn bộ giỏ hàng</button>
                    </form>
                    <div>
                        <a href="${pageContext.request.contextPath}/trang-chu" class="btn-continue">TIẾP TỤC MUA SẮM</a>
                        <a href="${pageContext.request.contextPath}/thanh-toan" class="btn-checkout">THANH TOÁN</a>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="footer.jsp" />
