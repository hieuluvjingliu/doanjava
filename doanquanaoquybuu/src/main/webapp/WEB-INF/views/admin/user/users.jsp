<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="page-heading">
    <div class="page-title">
        <div class="row">
            <div class="col-12 col-md-6 order-md-1 order-last">
                <h3>Quản Lý Khách Hàng</h3>
                <p class="text-subtitle text-muted">Danh sách tài khoản khách hàng đã đăng ký</p>
            </div>
        </div>
    </div>
</div>

<div class="page-content">
    <section class="section">
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped" id="table1">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ Tên</th>
                                <th>Email</th>
                                <th>SĐT</th>
                                <th>Địa Chỉ</th>
                                <th>Vai Trò</th>
                                <th>Trạng Thái</th>
                                <th>Ngày Tạo</th>
                                <th class="text-center">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty listUser}">
                                    <tr>
                                        <td colspan="9" class="text-center py-5">
                                            <i class="bi bi-people" style="font-size: 48px; color: #ccc;"></i>
                                            <p class="text-muted mt-2 mb-0">Chưa có khách hàng nào trong hệ thống.</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="user" items="${listUser}">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>${user.fullName}</td>
                                            <td>${user.email}</td>
                                            <td>${user.phone}</td>
                                            <td>${user.address}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.role == 'ADMIN'}">
                                                        <span class="badge bg-danger">Admin</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Khách hàng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.status == 'ACTIVE'}">
                                                        <span class="badge bg-success">Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger">Bị khóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" /></td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${user.role == 'ADMIN'}">
                                                        <span class="text-muted small"><i class="bi bi-shield-lock"></i> Bảo vệ</span>
                                                    </c:when>
                                                    <c:when test="${user.status == 'ACTIVE'}">
                                                        <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display:inline;">
                                                            <input type="hidden" name="action" value="toggleStatus">
                                                            <input type="hidden" name="id" value="${user.id}">
                                                            <input type="hidden" name="status" value="LOCKED">
                                                            <button type="submit" class="btn btn-sm btn-danger"
                                                                    onclick="return confirm('Khóa tài khoản khách hàng ${user.fullName}?')">
                                                                <i class="bi bi-lock"></i> Khóa
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display:inline;">
                                                            <input type="hidden" name="action" value="toggleStatus">
                                                            <input type="hidden" name="id" value="${user.id}">
                                                            <input type="hidden" name="status" value="ACTIVE">
                                                            <button type="submit" class="btn btn-sm btn-success"
                                                                    onclick="return confirm('Mở khóa tài khoản khách hàng ${user.fullName}?')">
                                                                <i class="bi bi-unlock"></i> Mở Khóa
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
</div>
