<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<jsp:include page="header.jsp" />

<style>
    .checkout-page { max-width: 1000px; margin: 40px auto; padding: 20px; }
    .checkout-title { font-size: 28px; font-weight: bold; text-align: center; margin-bottom: 30px; letter-spacing: 1px;}
    .checkout-form { background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    .form-section { margin-bottom: 25px; }
    .form-section h4 { font-weight: 600; margin-bottom: 15px; color: #333; border-bottom: 2px solid #000; padding-bottom: 10px; display: inline-block; }
    .form-group { margin-bottom: 15px; }
    .form-group label { font-weight: 500; margin-bottom: 5px; display: block; color: #555; }
    .form-group input, .form-group textarea, .form-group select { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; }
    .form-group input:focus, .form-group textarea:focus, .form-group select:focus { outline: none; border-color: #000; }
    .payment-methods { display: flex; gap: 20px; flex-wrap: wrap; }
    .payment-option { flex: 1; min-width: 200px; }
    .payment-option input[type="radio"] { display: none; }
    .payment-option label { display: block; padding: 20px; border: 2px solid #ddd; border-radius: 10px; cursor: pointer; text-align: center; transition: 0.3s; }
    .payment-option input[type="radio"]:checked + label { border-color: #000; background: #f5f5f5; }
    .payment-option label:hover { border-color: #999; }
    .payment-option .payment-icon { font-size: 30px; margin-bottom: 10px; }
    .payment-option .payment-title { font-weight: 600; display: block; }
    .payment-option .payment-desc { font-size: 12px; color: #888; margin-top: 5px; }
    .order-summary { background: #f9f9f9; padding: 20px; border-radius: 10px; margin-top: 20px; }
    .order-summary h4 { font-weight: 600; margin-bottom: 15px; }
    .order-item { display: flex; align-items: center; padding: 10px 0; border-bottom: 1px solid #eee; }
    .order-item:last-child { border-bottom: none; }
    .order-item img { width: 60px; height: 60px; object-fit: cover; border-radius: 5px; margin-right: 15px; }
    .order-item-info { flex: 1; }
    .order-item-name { font-weight: 500; }
    .order-item-variant { font-size: 12px; color: #888; }
    .order-item-price { font-weight: 600; color: #e74c3c; }
    .order-total { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-top: 2px solid #ddd; margin-top: 10px; font-size: 18px; font-weight: 600; }
    .order-total span:last-child { color: #e74c3c; font-size: 22px; }
    .btn-checkout { background-color: #000; color: #fff; border: none; padding: 15px 40px; font-size: 16px; font-weight: bold; border-radius: 5px; transition: 0.3s; cursor: pointer; width: 100%; margin-top: 20px; }
    .btn-checkout:hover { background-color: #333; }
    .success-page { text-align: center; padding: 60px 20px; }
    .success-icon { font-size: 80px; color: #27ae60; margin-bottom: 20px; }
    .success-title { font-size: 28px; font-weight: bold; margin-bottom: 15px; }
    .success-desc { color: #666; margin-bottom: 30px; }
    .btn-continue { background-color: #000; color: #fff; border: none; padding: 15px 40px; font-size: 16px; font-weight: bold; border-radius: 5px; text-decoration: none; display: inline-block; }
    .btn-continue:hover { background-color: #333; color: white; }
    .order-id { font-size: 20px; font-weight: 600; color: #27ae60; margin: 20px 0; }
    @media (max-width: 768px) {
        .checkout-page { padding: 10px; }
        .checkout-form { padding: 20px; }
    }
</style>

<div class="container">
    <div class="checkout-page">
        <h2 class="checkout-title"><i class="fa-solid fa-credit-card"></i> THANH TOÁN</h2>

        <c:if test="${param.success == 'true'}">
            <div class="success-page">
                <div class="success-icon"><i class="fa-solid fa-circle-check"></i></div>
                <h1 class="success-title">Đặt Hàng Thành Công!</h1>
                <p class="success-desc">Cảm ơn bạn đã đặt hàng. Đơn hàng của bạn đang được xử lý.</p>
                <p class="order-id">Mã đơn hàng: #${param.orderId}</p>
                <a href="${pageContext.request.contextPath}/trang-chu" class="btn-continue">TIẾP TỤC MUA SẮM</a>
            </div>
        </c:if>

        <c:if test="${param.success != 'true'}">
            <div class="checkout-form">
                <form action="${pageContext.request.contextPath}/thanh-toan" method="post">
                    <div class="row">
                        <div class="col-md-7">
                            <div class="form-section">
                                <h4><i class="fa-solid fa-user"></i> Thông Tin Người Nhận</h4>
                                
                                <div class="form-group">
                                    <label>Họ và tên *</label>
                                    <input type="text" name="receiverName" value="${user != null ? user.fullName : ''}" required>
                                </div>
                                
                                <div class="form-group">
                                    <label>Số điện thoại *</label>
                                    <input type="tel" name="receiverPhone" value="${user != null ? user.phone : ''}" required>
                                </div>
                                
                                <div class="form-group">
                                    <label>Địa chỉ nhận hàng *</label>
                                    <textarea name="receiverAddress" rows="3" required>${user != null ? user.address : ''}</textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label>Ghi chú (tùy chọn)</label>
                                    <textarea name="note" rows="2" placeholder="Ví dụ: Giao giờ hành chính, gọi trước khi giao..."></textarea>
                                </div>
                            </div>

                            <div class="form-section">
                                <h4><i class="fa-solid fa-wallet"></i> Phương Thức Thanh Toán</h4>
                                
                                <div class="payment-methods">
                                    <div class="payment-option">
                                        <input type="radio" name="paymentMethod" id="cod" value="COD" checked>
                                        <label for="cod">
                                            <div class="payment-icon"><i class="fa-solid fa-money-bill-wave"></i></div>
                                            <span class="payment-title">COD</span>
                                            <span class="payment-desc">Thanh toán khi nhận hàng</span>
                                        </label>
                                    </div>
                                    
                                    <div class="payment-option">
                                        <input type="radio" name="paymentMethod" id="bank" value="BANK_TRANSFER">
                                        <label for="bank">
                                            <div class="payment-icon"><i class="fa-solid fa-university"></i></div>
                                            <span class="payment-title">Chuyển khoản</span>
                                            <span class="payment-desc">Chuyển khoản ngân hàng</span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-5">
                            <div class="order-summary">
                                <h4><i class="fa-solid fa-cart-shopping"></i> Đơn Hàng Của Bạn</h4>
                                
                                <c:forEach var="item" items="${cartItems}">
                                    <div class="order-item">
                                        <img src="<my:safeImage value='${item.productImage}' width='60' height='60'/>" alt="${item.productName}">
                                        <div class="order-item-info">
                                            <div class="order-item-name">${item.productName}</div>
                                            <div class="order-item-variant">Số lượng: ${item.quantity}</div>
                                        </div>
                                        <div class="order-item-price">
                                            <fmt:formatNumber value="${item.total}" pattern="#,### VNĐ" />
                                        </div>
                                    </div>
                                </c:forEach>
                                
                                <div class="order-total">
                                    <span>TỔNG CỘNG:</span>
                                    <span><fmt:formatNumber value="${cartTotal}" pattern="#,### VNĐ" /></span>
                                </div>
                                
                                <button type="submit" class="btn-checkout">
                                    <i class="fa-solid fa-lock"></i> ĐẶT HÀNG NGAY
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="footer.jsp" />
