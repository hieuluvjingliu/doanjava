<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="page-heading">
    <div class="page-title">
        <div class="row">
            <div class="col-12 col-md-6 order-md-1 order-last">
                <h3>Quản Lý Đơn Hàng</h3>
                <p class="text-subtitle text-muted">Danh sách tất cả đơn hàng</p>
            </div>
        </div>
    </div>
</div>

<div class="page-content">
    <section class="section">
        <div class="card">
            <div class="card-header">
                <h4>Danh Sách Đơn Hàng</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped" id="table1">
                        <thead>
                            <tr>
                                <th>Mã ĐH</th>
                                <th>Khách Hàng</th>
                                <th>SĐT</th>
                                <th>Địa Chỉ</th>
                                <th>Tổng Tiền</th>
                                <th>Thanh Toán</th>
                                <th>Trạng Thái</th>
                                <th>Ngày Tạo</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>#${order.id}</td>
                                    <td>${order.receiverName}</td>
                                    <td>${order.receiverPhone}</td>
                                    <td>
                                        <span title="${order.receiverAddress}">
                                            ${order.receiverAddress.length() > 30 ? order.receiverAddress.substring(0, 30).concat('...') : order.receiverAddress}
                                        </span>
                                    </td>
                                    <td><fmt:formatNumber value="${order.totalAmount}" pattern="#,### VNĐ" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.paymentMethod == 'COD'}">
                                                <span class="badge bg-secondary">COD</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-primary">Chuyển khoản</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.orderStatus == 'PENDING'}">
                                                <span class="badge bg-warning">Chờ xác nhận</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'CONFIRMED'}">
                                                <span class="badge bg-info">Đã xác nhận</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'SHIPPING'}">
                                                <span class="badge bg-primary">Đang giao</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'FINISH'}">
                                                <span class="badge bg-success">Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'CANCELLED'}">
                                                <span class="badge bg-danger">Đã hủy</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>${order.createdAtFormatted}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${order.id}" class="btn btn-sm btn-primary">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
</div>
