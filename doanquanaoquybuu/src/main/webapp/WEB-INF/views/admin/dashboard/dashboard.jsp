<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="page-heading">
    <div class="page-title">
        <div class="row">
            <div class="col-12 col-md-6 order-md-1 order-last">
                <h3>Dashboard</h3>
                <p class="text-subtitle text-muted">Tổng quan cửa hàng QUYBUU</p>
            </div>
        </div>
    </div>
</div>

<div class="page-content">
    <section class="row">
        <div class="col-12 col-lg-3 col-md-6">
            <div class="card">
                <div class="card-body px-4 py-4-5">
                    <div class="row">
                        <div class="col-md-4 col-lg-12 col-xl-5 col-12">
                            <div class="stats-icon purple mb-2">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                        <div class="col-md-8 col-lg-12 col-xl-7 col-12">
                            <h6 class="text-muted font-semibold">Người Dùng</h6>
                            <h3 class="mb-0 fw-bold">${totalUsers != null ? totalUsers : 0}</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-lg-3 col-md-6">
            <div class="card">
                <div class="card-body px-4 py-4-5">
                    <div class="row">
                        <div class="col-md-4 col-lg-12 col-xl-5 col-12">
                            <div class="stats-icon blue mb-2">
                                <i class="bi bi-box-seam"></i>
                            </div>
                        </div>
                        <div class="col-md-8 col-lg-12 col-xl-7 col-12">
                            <h6 class="text-muted font-semibold">Sản Phẩm</h6>
                            <h3 class="mb-0 fw-bold">${totalProducts != null ? totalProducts : 0}</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-lg-3 col-md-6">
            <div class="card">
                <div class="card-body px-4 py-4-5">
                    <div class="row">
                        <div class="col-md-4 col-lg-12 col-xl-5 col-12">
                            <div class="stats-icon green mb-2">
                                <i class="bi bi-cart-fill"></i>
                            </div>
                        </div>
                        <div class="col-md-8 col-lg-12 col-xl-7 col-12">
                            <h6 class="text-muted font-semibold">Đơn Hàng</h6>
                            <h3 class="mb-0 fw-bold">${totalOrders != null ? totalOrders : 0}</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-lg-3 col-md-6">
            <div class="card">
                <div class="card-body px-4 py-4-5">
                    <div class="row">
                        <div class="col-md-4 col-lg-12 col-xl-5 col-12">
                            <div class="stats-icon red mb-2">
                                <i class="bi bi-currency-dollar"></i>
                            </div>
                        </div>
                        <div class="col-md-8 col-lg-12 col-xl-7 col-12">
                            <h6 class="text-muted font-semibold">Doanh Thu</h6>
                            <h3 class="mb-0 fw-bold"><fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" pattern="#,###" />đ</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h4>Đơn Hàng Gần Đây</h4>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped mb-0">
                            <thead>
                                <tr>
                                    <th>Mã ĐH</th>
                                    <th>Khách Hàng</th>
                                    <th>Tổng Tiền</th>
                                    <th>Trạng Thái</th>
                                    <th>Ngày Tạo</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${recentOrders}">
                                    <tr>
                                        <td>#${order.id}</td>
                                        <td>${order.receiverName}</td>
                                        <td><fmt:formatNumber value="${order.totalAmount}" pattern="#,### VNĐ" /></td>
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
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Đã hủy</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${order.createdAtFormatted}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentOrders}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted">Chưa có đơn hàng nào</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<style>
.stats-icon {
    width: 52px;
    height: 52px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
}
.stats-icon.purple { background: #eb98ff; color: #8B5CF6; }
.stats-icon.blue { background: #93c5fd; color: #3B82F6; }
.stats-icon.green { background: #86efac; color: #22C55E; }
.stats-icon.red { background: #fca5a5; color: #EF4444; }
</style>
