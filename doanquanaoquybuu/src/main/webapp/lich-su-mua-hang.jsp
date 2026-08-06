<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<jsp:include page="header.jsp" />

<style>
    .history-page { max-width: 1000px; margin: 40px auto; padding: 20px; }
    .history-title { font-size: 28px; font-weight: bold; text-align: center; margin-bottom: 30px; letter-spacing: 1px;}
    .order-card { background: #fff; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 20px; overflow: hidden; }
    .order-header { background: #f8f9fa; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; }
    .order-id { font-weight: 700; color: #333; font-size: 18px; }
    .order-date { color: #888; font-size: 14px; }
    .order-body { padding: 20px; }
    .order-status { display: inline-block; padding: 5px 15px; border-radius: 20px; font-size: 12px; font-weight: 600; }
    .status-pending { background: #fff3cd; color: #856404; }
    .status-confirmed { background: #d1ecf1; color: #0c5460; }
    .status-shipping { background: #cce5ff; color: #004085; }
    .status-finish { background: #d4edda; color: #155724; }
    .status-cancelled { background: #f8d7da; color: #721c24; }
    .order-item { display: flex; align-items: center; padding: 10px 0; border-bottom: 1px solid #eee; }
    .order-item:last-child { border-bottom: none; }
    .order-item img { width: 60px; height: 60px; object-fit: cover; border-radius: 5px; margin-right: 15px; }
    .order-item-info { flex: 1; }
    .order-item-name { font-weight: 500; }
    .order-item-qty { font-size: 13px; color: #888; }
    .order-item-price { font-weight: 600; color: #e74c3c; }
    .order-footer { padding: 15px 20px; background: #f8f9fa; display: flex; justify-content: space-between; align-items: center; }
    .order-total { font-weight: 700; font-size: 16px; }
    .order-total span { color: #e74c3c; font-size: 20px; }
    .empty-history { text-align: center; padding: 60px 20px; }
    .empty-history i { font-size: 80px; color: #ccc; margin-bottom: 20px; }
    .btn-shopping { background-color: #000; color: #fff; border: none; padding: 15px 30px; font-size: 16px; font-weight: bold; border-radius: 5px; text-decoration: none; display: inline-block; margin-top: 20px; }
    .btn-shopping:hover { background-color: #333; color: white; }
</style>

<div class="container">
    <div class="history-page">
        <h2 class="history-title"><i class="fa-solid fa-clock-rotate-left"></i> LỊCH SỬ MUA HÀNG</h2>

        <c:if test="${empty orders}">
            <div class="empty-history">
                <i class="fa-solid fa-bag-shopping"></i>
                <h3>Bạn chưa có đơn hàng nào</h3>
                <p class="text-muted">Hãy bắt đầu mua sắm để tích lũy đơn hàng nhé!</p>
                <a href="${pageContext.request.contextPath}/trang-chu" class="btn-shopping">BẮT ĐẦU MUA SẮM</a>
            </div>
        </c:if>

        <c:forEach var="order" items="${orders}">
            <div class="order-card">
                <div class="order-header">
                    <div>
                        <span class="order-id">Đơn hàng #${order.id}</span>
                        <span class="order-date ms-3"><i class="fa-regular fa-calendar"></i> ${order.createdAtFormatted}</span>
                    </div>
                    <c:choose>
                        <c:when test="${order.orderStatus == 'PENDING'}">
                            <span class="order-status status-pending"><i class="fa-solid fa-clock"></i> Chờ xác nhận</span>
                        </c:when>
                        <c:when test="${order.orderStatus == 'CONFIRMED'}">
                            <span class="order-status status-confirmed"><i class="fa-solid fa-check"></i> Đã xác nhận</span>
                        </c:when>
                        <c:when test="${order.orderStatus == 'SHIPPING'}">
                            <span class="order-status status-shipping"><i class="fa-solid fa-truck"></i> Đang giao hàng</span>
                        </c:when>
                        <c:when test="${order.orderStatus == 'FINISH'}">
                            <span class="order-status status-finish"><i class="fa-solid fa-circle-check"></i> Hoàn thành</span>
                        </c:when>
                        <c:when test="${order.orderStatus == 'CANCELLED'}">
                            <span class="order-status status-cancelled"><i class="fa-solid fa-xmark"></i> Đã hủy</span>
                        </c:when>
                    </c:choose>
                </div>
                <div class="order-body">
                    <p class="mb-2"><i class="fa-solid fa-user me-2"></i> <strong>Người nhận:</strong> ${order.receiverName}</p>
                    <p class="mb-2"><i class="fa-solid fa-phone me-2"></i> <strong>SĐT:</strong> ${order.receiverPhone}</p>
                    <p class="mb-2"><i class="fa-solid fa-location-dot me-2"></i> <strong>Địa chỉ:</strong> ${order.receiverAddress}</p>
                    <c:if test="${not empty order.note}">
                        <p class="mb-0"><i class="fa-solid fa-note-sticky me-2"></i> <strong>Ghi chú:</strong> ${order.note}</p>
                    </c:if>
                    <hr>
                    <c:forEach var="item" items="${order.items}">
                        <div class="order-item">
                            <img src="<my:safeImage value='${item.productImage}' width='60' height='60'/>" alt="${item.productName}">
                            <div class="order-item-info">
                                <div class="order-item-name">${item.productName}</div>
                                <div class="order-item-qty">Phân loại: ${item.colorName} - ${item.sizeName} | SL: ${item.quantity}</div>
                            </div>
                            <div class="order-item-price"><fmt:formatNumber value="${item.lineTotal}" pattern="#,### VNĐ" /></div>
                        </div>
                    </c:forEach>
                </div>
                <div class="order-footer">
                    <span class="order-total">Tổng cộng: <span><fmt:formatNumber value="${order.totalAmount}" pattern="#,### VNĐ" /></span></span>
                    <span class="badge bg-secondary"><i class="fa-solid fa-credit-card"></i> ${order.paymentMethod == 'COD' ? 'COD' : 'Chuyển khoản'}</span>
                </div>
            </div>
        </c:forEach>

        <c:if test="${not empty orders}">
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/trang-chu" class="btn-shopping">TIẾP TỤC MUA SẮM</a>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="footer.jsp" />
