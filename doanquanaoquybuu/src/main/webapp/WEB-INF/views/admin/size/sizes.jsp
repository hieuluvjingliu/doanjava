<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="page-heading">
    <div class="page-title">
        <div class="row">
            <div class="col-12 col-md-6 order-md-1 order-last">
                <h3>Quản Lý Kích Thước</h3>
                <p class="text-subtitle text-muted">Thêm, sửa, xóa kích thước sản phẩm (size: S, M, L, XL...)</p>
            </div>
            <div class="col-12 col-md-6 order-md-1 order-first">
                <div class="float-start float-lg-end">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
                        <i class="bi bi-plus"></i> Thêm Kích Thước
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<c:if test="${param.msg == 'added'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> Đã thêm kích thước mới.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'updated'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> Đã cập nhật kích thước.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'deleted'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> Đã xóa kích thước.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="page-content">
    <section class="section">
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped" id="table1">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên Kích Thước</th>
                                <th class="text-center">Thứ Tự</th>
                                <th>Trạng Thái</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="kt" items="${listKichThuoc}">
                                <tr>
                                    <td>${kt.id}</td>
                                    <td><strong>${kt.name}</strong></td>
                                    <td class="text-center">${kt.sortOrder}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${kt.status == 'ACTIVE'}">
                                                <span class="badge bg-success">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Không hoạt động</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/kich-thuoc?action=edit&id=${kt.id}" class="btn btn-sm btn-primary">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/kich-thuoc?action=delete&id=${kt.id}"
                                           class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn xóa kích thước này?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listKichThuoc}">
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">Chưa có kích thước nào</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
</div>

<!-- Add Modal -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm Kích Thước Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/kich-thuoc" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên Kích Thước</label>
                        <input type="text" name="name" class="form-control" placeholder="VD: S, M, L, XL, XXL, Free Size..." required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Thứ Tự Hiển Thị</label>
                        <input type="number" name="sortOrder" class="form-control" value="0" required>
                        <small class="text-muted">Số nhỏ hơn sẽ hiển thị trước</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng Thái</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE">Hoạt động</option>
                            <option value="INACTIVE">Không hoạt động</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Thêm</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Modal -->
<c:if test="${not empty editingKichThuoc}">
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cập Nhật Kích Thước</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/kich-thuoc" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${editingKichThuoc.id}">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên Kích Thước</label>
                        <input type="text" name="name" class="form-control" value="${editingKichThuoc.name}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Thứ Tự Hiển Thị</label>
                        <input type="number" name="sortOrder" class="form-control" value="${editingKichThuoc.sortOrder}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng Thái</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE" ${editingKichThuoc.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                            <option value="INACTIVE" ${editingKichThuoc.status == 'INACTIVE' ? 'selected' : ''}>Không hoạt động</option>
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