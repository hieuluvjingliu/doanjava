<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>

<div class="page-heading">
    <div class="page-title">
        <div class="row">
            <div class="col-12 col-md-6 order-md-1 order-last">
                <h3>Chi Tiết Đơn Hàng #${order.id}</h3>
            </div>
            <div class="col-12 col-md-6 order-md-1 order-first">
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>
    </div>
</div>

<div class="page-content">
    <div class="row">
        <div class="col-12 col-lg-4">
            <div class="card">
                <div class="card-header">
                    <h4>Thông Tin Người Nhận</h4>
                </div>
                <div class="card-body">
                    <p><strong>Họ tên:</strong> ${order.receiverName}</p>
                    <p><strong>SĐT:</strong> ${order.receiverPhone}</p>
                    <p><strong>Địa chỉ:</strong> ${order.receiverAddress}</p>
                    <c:if test="${not empty order.note}">
                        <p><strong>Ghi chú:</strong> ${order.note}</p>
                    </c:if>
                </div>
            </div>
        </div>
        
        <div class="col-12 col-lg-4">
            <div class="card">
                <div class="card-header">
                    <h4>Thông Tin Thanh Toán</h4>
                </div>
                <div class="card-body">
                    <p><strong>Tổng tiền:</strong> <span class="text-danger fw-bold"><fmt:formatNumber value="${order.totalAmount}" pattern="#,### VNĐ" /></span></p>
                    <p><strong>Thanh toán:</strong> 
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'COD'}">COD - Khi nhận hàng</c:when>
                            <c:otherwise>Chuyển khoản</c:otherwise>
                        </c:choose>
                    </p>
                    <p><strong>Ngày đặt:</strong> ${order.createdAtFormatted}</p>
                </div>
            </div>
        </div>
        
        <div class="col-12 col-lg-4">
            <div class="card">
                <div class="card-header">
                    <h4>Cập Nhật Trạng Thái</h4>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="get">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="id" value="${order.id}">
                        <div class="mb-3">
                            <select name="status" class="form-select">
                                <option value="PENDING" ${order.orderStatus == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                                <option value="CONFIRMED" ${order.orderStatus == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                <option value="SHIPPING" ${order.orderStatus == 'SHIPPING' ? 'selected' : ''}>Đang giao hàng</option>
                                <option value="FINISH" ${order.orderStatus == 'FINISH' ? 'selected' : ''}>Hoàn thành</option>
                                <option value="CANCELLED" ${order.orderStatus == 'CANCELLED' ? 'selected' : ''}>Hủy đơn</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Cập nhật</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row mt-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h4>Sản Phẩm Trong Đơn</h4>
                </div>
                <div class="card-body">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Ảnh</th>
                                <th>Tên Sản Phẩm</th>
                                <th>Phân Loại</th>
                                <th>Giá</th>
                                <th>Số Lượng</th>
                                <th>Tạm Tính</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${details}">
                                <tr>
                                    <td><img src="<my:safeImage value='${item.productImage}' width='60' height='60'/>" width="60" height="60" style="object-fit:cover; border-radius:5px;"></td>
                                    <td>${item.productName}</td>
                                    <td>${item.colorName} - ${item.sizeName}</td>
                                    <td><fmt:formatNumber value="${item.priceAtPurchase}" pattern="#,### VNĐ" /></td>
                                    <td>${item.quantity}</td>
                                    <td><fmt:formatNumber value="${item.lineTotal}" pattern="#,### VNĐ" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
