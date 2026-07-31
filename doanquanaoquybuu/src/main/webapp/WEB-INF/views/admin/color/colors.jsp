<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="page-heading">
    <div class="page-title">
        <div class="row">
            <div class="col-12 col-md-6 order-md-1 order-last">
                <h3>Quản Lý Màu Sắc</h3>
                <p class="text-subtitle text-muted">Thêm, sửa, xóa màu sắc sản phẩm</p>
            </div>
            <div class="col-12 col-md-6 order-md-1 order-first">
                <div class="float-start float-lg-end">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
                        <i class="bi bi-plus"></i> Thêm Màu Sắc
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<c:if test="${param.msg == 'added'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> Đã thêm màu sắc mới.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'updated'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> Đã cập nhật màu sắc.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'deleted'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> Đã xóa màu sắc.
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
                                <th>Tên Màu Sắc</th>
                                <th>Trạng Thái</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ms" items="${listMauSac}">
                                <tr>
                                    <td>${ms.id}</td>
                                    <td><strong>${ms.name}</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ms.status == 'ACTIVE'}">
                                                <span class="badge bg-success">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Không hoạt động</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/mau-sac?action=edit&id=${ms.id}" class="btn btn-sm btn-primary">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/mau-sac?action=delete&id=${ms.id}"
                                           class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn xóa màu sắc này?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listMauSac}">
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-4">Chưa có màu sắc nào</td>
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
                <h5 class="modal-title">Thêm Màu Sắc Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/mau-sac" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên Màu Sắc</label>
                        <input type="text" name="name" class="form-control" placeholder="VD: Đỏ, Xanh dương, Đen, Trắng..." required>
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
<c:if test="${not empty editingMauSac}">
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cập Nhật Màu Sắc</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/mau-sac" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${editingMauSac.id}">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên Màu Sắc</label>
                        <input type="text" name="name" class="form-control" value="${editingMauSac.name}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng Thái</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE" ${editingMauSac.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                            <option value="INACTIVE" ${editingMauSac.status == 'INACTIVE' ? 'selected' : ''}>Không hoạt động</option>
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