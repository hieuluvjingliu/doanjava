<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags"%>

<style>
    .qb-stock-badge {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
        min-width: 60px;
        text-align: center;
    }
    .qb-stock-empty { background: #fde2e2; color: #b91c1c; }
    .qb-stock-low   { background: #fff3cd; color: #92400e; }
    .qb-stock-ok    { background: #d1fae5; color: #065f46; }
    .qb-action-cell { white-space: nowrap; }
    .qb-action-cell .btn { margin-right: 2px; }
</style>

<div class="page-heading">
    <div class="page-title">
        <div class="row">
            <div class="col-12 col-md-6 order-md-1 order-last">
                <h3>Quản Lý Sản Phẩm</h3>
                <p class="text-subtitle text-muted">Thêm, sửa, xóa sản phẩm và quản lý tồn kho</p>
            </div>
            <div class="col-12 col-md-6 order-md-1 order-first">
                <div class="float-start float-lg-end">
                    <a href="${pageContext.request.contextPath}/admin/kich-thuoc" class="btn btn-outline-secondary me-1">
                        <i class="bi bi-rulers"></i> Quản Lý Size
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/mau-sac" class="btn btn-outline-secondary me-1">
                        <i class="bi bi-palette"></i> Quản Lý Màu
                    </a>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
                        <i class="bi bi-plus"></i> Thêm Sản Phẩm
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<c:if test="${param.msg == 'added'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> Đã thêm sản phẩm mới.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'updated'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> Đã cập nhật sản phẩm.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'deleted'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> Đã xóa sản phẩm.
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
                                <th>Ảnh</th>
                                <th>Tên Sản Phẩm</th>
                                <th>Danh Mục</th>
                                <th>Giá Cơ Bản</th>
                                <th class="text-center">Tồn Kho</th>
                                <th>Trạng Thái</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="sp" items="${listSanPham}">
                                <tr>
                                    <td>${sp.id}</td>
                                    <td>
                                        <img src="<my:safeImage value='${sp.image}' width='50' height='50'/>" width="50" height="50" style="object-fit: cover; border-radius: 5px;">
                                    </td>
                                    <td><strong>${sp.name}</strong></td>
                                    <td>
                                        <c:forEach var="dm" items="${listDanhMuc}">
                                            <c:if test="${dm.id == sp.categoryId}">${dm.name}</c:if>
                                        </c:forEach>
                                    </td>
                                    <td><fmt:formatNumber value="${sp.basePrice}" pattern="#,### VNĐ" /></td>
                                    <td class="text-center">
                                        <c:set var="totalStock" value="${totalStockMap[sp.id]}" />
                                        <c:choose>
                                            <c:when test="${totalStock == 0}">
                                                <span class="qb-stock-badge qb-stock-empty" title="Chưa có biến thể hoặc hết hàng">Hết</span>
                                            </c:when>
                                            <c:when test="${totalStock < 10}">
                                                <span class="qb-stock-badge qb-stock-low" title="Tồn kho thấp">${totalStock}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="qb-stock-badge qb-stock-ok">${totalStock}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${sp.status == 'ACTIVE'}">
                                                <span class="badge bg-success">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Không hoạt động</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="qb-action-cell">
                                        <a href="${pageContext.request.contextPath}/admin/san-pham-chi-tiet?productId=${sp.id}" class="btn btn-sm btn-warning" title="Quản lý biến thể / tồn kho">
                                            <i class="bi bi-box-seam"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/chi-tiet?id=${sp.id}" target="_blank" class="btn btn-sm btn-info" title="Xem ngoài trang">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${sp.id}" class="btn btn-sm btn-primary" title="Sửa sản phẩm">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${sp.id}"
                                           class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn xóa?')" title="Xóa sản phẩm">
                                            <i class="bi bi-trash"></i>
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

<!-- Add Modal -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm Sản Phẩm Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/products" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Tên Sản Phẩm</label>
                                <input type="text" name="name" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Danh Mục</label>
                                <select name="categoryId" class="form-select" required>
                                    <c:forEach var="dm" items="${listDanhMuc}">
                                        <option value="${dm.id}">${dm.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giá Cơ Bản</label>
                                <input type="number" name="basePrice" class="form-control" required min="0">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Trạng Thái</label>
                                <select name="status" class="form-select">
                                    <option value="ACTIVE">Hoạt động</option>
                                    <option value="INACTIVE">Không hoạt động</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">URL ảnh (placehold.co)</label>
                                <input type="text" name="imageUrl" class="form-control" placeholder="https://placehold.co/400x400?text=Ten+SP">
                                <small class="text-muted">Dán link ảnh từ placehold.co hoặc URL bất kỳ</small>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô Tả</label>
                        <textarea name="description" class="form-control" rows="4"></textarea>
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
<c:if test="${not empty editingSanPham}">
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cập Nhật Sản Phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/products" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${editingSanPham.id}">
                <input type="hidden" name="oldImage" value="${editingSanPham.image}">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Tên Sản Phẩm</label>
                                <input type="text" name="name" class="form-control" value="${editingSanPham.name}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Danh Mục</label>
                                <select name="categoryId" class="form-select" required>
                                    <c:forEach var="dm" items="${listDanhMuc}">
                                        <option value="${dm.id}" ${dm.id == editingSanPham.categoryId ? 'selected' : ''}>${dm.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giá Cơ Bản</label>
                                <input type="number" name="basePrice" class="form-control" value="${editingSanPham.basePrice}" required min="0">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Trạng Thái</label>
                                <select name="status" class="form-select">
                                    <option value="ACTIVE" ${editingSanPham.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="INACTIVE" ${editingSanPham.status == 'INACTIVE' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">URL ảnh hiện tại</label>
                                <input type="text" class="form-control" value="${editingSanPham.image}" readonly>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">URL ảnh mới (để trống nếu giữ nguyên)</label>
                                <input type="text" name="imageUrl" class="form-control" placeholder="https://placehold.co/400x400?text=...">
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô Tả</label>
                        <textarea name="description" class="form-control" rows="4">${editingSanPham.description}</textarea>
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
