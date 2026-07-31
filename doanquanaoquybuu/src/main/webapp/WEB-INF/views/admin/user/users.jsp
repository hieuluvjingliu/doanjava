<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="page-heading">
    <div class="page-title">
        <div class="row">
            <div class="col-12 col-md-6 order-md-1 order-last">
                <h3>Quản Lý Người Dùng</h3>
                <p class="text-subtitle text-muted">Danh sách tài khoản người dùng</p>
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
                                <th>Vai Trò</th>
                                <th>Trạng Thái</th>
                                <th>Ngày Tạo</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${listUser}">
                                <tr>
                                    <td>${user.id}</td>
                                    <td>${user.fullName}</td>
                                    <td>${user.email}</td>
                                    <td>${user.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.role == 'ADMIN'}">
                                                <span class="badge bg-danger">Admin</span>
                                            </c:when>
                                            <c:when test="${user.role == 'STAFF'}">
                                                <span class="badge bg-warning">Nhân viên</span>
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
                                    <td>
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

<!-- Edit Modal -->
<c:if test="${not empty editingUser}">
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cập Nhật Người Dùng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/users" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${editingUser.id}">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Email (không thể đổi)</label>
                        <input type="text" class="form-control" value="${editingUser.email}" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Họ Tên</label>
                        <input type="text" name="fullName" class="form-control" value="${editingUser.fullName}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số Điện Thoại</label>
                        <input type="text" name="phone" class="form-control" value="${editingUser.phone}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Địa Chỉ</label>
                        <input type="text" name="address" class="form-control" value="${editingUser.address}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Vai Trò</label>
                        <select name="role" class="form-select">
                            <option value="CUSTOMER" ${editingUser.role == 'CUSTOMER' ? 'selected' : ''}>Khách hàng</option>
                            <option value="STAFF" ${editingUser.role == 'STAFF' ? 'selected' : ''}>Nhân viên</option>
                            <option value="ADMIN" ${editingUser.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng Thái</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE" ${editingUser.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                            <option value="INACTIVE" ${editingUser.status == 'INACTIVE' ? 'selected' : ''}>Bị khóa</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-warning">Cập nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>
</c:if>

<c:if test="${openEditModal}">
<script>
document.addEventListener('DOMContentLoaded', function() {
    var el = document.getElementById('editModal');
    if (el) {
        var modal = new bootstrap.Modal(el);
        modal.show();
    }
});
</script>
</c:if>
