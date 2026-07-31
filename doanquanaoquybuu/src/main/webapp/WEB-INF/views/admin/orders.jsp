<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="page-heading">
    <div class="page-title">
        <div class="row">
            <div class="col-12 col-md-6 order-md-1 order-last">
                <h3>Quản Lý Đơn Hàng</h3>
                <p class="text-subtitle text-muted">Danh sách tất cả đơn hàng (${totalOrders})</p>
            </div>
            <div class="col-12 col-md-6 order-md-1 order-first">
                <div class="float-start float-lg-end">
                    <span class="badge bg-light-primary">
                        Trang ${currentPage} / ${totalPages}
                    </span>
                </div>
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
                            <c:choose>
                                <c:when test="${empty orders}">
                                    <tr>
                                        <td colspan="9" class="text-center py-5">
                                            <i class="bi bi-inbox" style="font-size: 48px; color: #ccc;"></i>
                                            <p class="text-muted mt-2 mb-0">Chưa có đơn hàng nào trong hệ thống.</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="order" items="${orders}">
                                        <tr>
                                            <td>#${order.id}</td>
                                            <td>${order.receiverName}</td>
                                            <td>${order.receiverPhone}</td>
                                            <td>
                                                <span title="${order.receiverAddress}">
                                                    <c:set var="addr" value="${order.receiverAddress}" />
                                                    <c:choose>
                                                        <c:when test="${empty addr}">
                                                            <em class="text-muted">(Không có)</em>
                                                        </c:when>
                                                        <c:when test="${addr.length() > 30}">
                                                            ${addr.substring(0, 30).concat('...')}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${addr}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td><fmt:formatNumber value="${order.totalAmount}" pattern="#,###" /> ₫</td>
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
                                                <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${order.id}" class="btn btn-sm btn-primary" title="Xem chi tiết">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="mt-3">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=1">
                                    <i class="bi bi-chevron-double-left"></i>
                                </a>
                            </li>
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}">${i}</a>
                                    </li>
                                </c:if>
                                <c:if test="${(i == currentPage - 3 && currentPage > 4) || (i == currentPage + 3 && currentPage < totalPages - 3)}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                </c:if>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${totalPages}">
                                    <i class="bi bi-chevron-double-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </section>
</div>
