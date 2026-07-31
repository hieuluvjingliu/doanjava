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
                <h3>Quản Lý Biến Thể / Tồn Kho</h3>
                <p class="text-subtitle text-muted">Sản phẩm ID: <strong>${productId}</strong> &mdash; Quản lý từng biến thể (màu + size + tồn kho)</p>
            </div>
            <div class="col-12 col-md-6 order-md-1 order-first">
                <div class="float-start float-lg-end">
                    <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary me-1">
                        <i class="bi bi-arrow-left"></i> Quay Lại Sản Phẩm
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/kich-thuoc" class="btn btn-outline-secondary me-1">
                        <i class="bi bi-rulers"></i> Quản Lý Size
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/mau-sac" class="btn btn-outline-secondary me-1">
                        <i class="bi bi-palette"></i> Quản Lý Màu
                    </a>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
                        <i class="bi bi-plus"></i> Thêm Biến Thể
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<c:if test="${param.msg == 'success' || param.msg == 'added'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> Đã lưu biến thể thành công.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'updated'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> Đã cập nhật biến thể.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'deleted'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> Đã xóa biến thể.
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
                                <th>SKU</th>
                                <th>Màu Sắc</th>
                                <th>Kích Thước</th>
                                <th>Giá Bán Riêng</th>
                                <th class="text-center">Tồn Kho</th>
                                <th>Trạng Thái</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ct" items="${listSPCT}">
                                <tr>
                                    <td><code>${ct.sku}</code></td>
                                    <td>
                                        <c:forEach var="ms" items="${listMauSac}">
                                            <c:if test="${ms.id == ct.colorId}">${ms.name}</c:if>
                                        </c:forEach>
                                    </td>
                                    <td>
                                        <c:forEach var="kt" items="${listKichThuoc}">
                                            <c:if test="${kt.id == ct.sizeId}">${kt.name}</c:if>
                                        </c:forEach>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ct.price == null}">
                                                <span class="text-muted">Theo giá gốc</span>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${ct.price}" pattern="#,###"/> ₫
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${ct.quantity == 0}">
                                                <span class="qb-stock-badge qb-stock-empty">Hết</span>
                                            </c:when>
                                            <c:when test="${ct.quantity < 5}">
                                                <span class="qb-stock-badge qb-stock-low">${ct.quantity}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="qb-stock-badge qb-stock-ok">${ct.quantity}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ct.status == 'ACTIVE'}">
                                                <span class="badge bg-success">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Ngừng bán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="qb-action-cell">
                                        <a href="${pageContext.request.contextPath}/admin/san-pham-chi-tiet?action=edit&productId=${productId}&id=${ct.id}" class="btn btn-sm btn-primary">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/san-pham-chi-tiet?action=delete&productId=${productId}&id=${ct.id}"
                                           class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn xóa biến thể này?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listSPCT}">
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">
                                        Chưa có biến thể nào. Click <strong>"Thêm Biến Thể"</strong> để bắt đầu.
                                    </td>
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
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm Biến Thể</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/san-pham-chi-tiet" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="productId" value="${productId}">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Màu Sắc</label>
                                <select name="colorId" class="form-select" required>
                                    <option value="">-- Chọn màu --</option>
                                    <c:forEach var="ms" items="${listMauSac}">
                                        <option value="${ms.id}">${ms.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Kích Thước</label>
                                <select name="sizeId" class="form-select" required>
                                    <option value="">-- Chọn size --</option>
                                    <c:forEach var="kt" items="${listKichThuoc}">
                                        <option value="${kt.id}">${kt.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mã Lưu Kho (SKU)</label>
                        <input type="text" name="sku" class="form-control" placeholder="VD: AO-001-DO-L" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Số Lượng Tồn</label>
                                <input type="number" name="quantity" class="form-control" value="0" required min="0">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Giá Bán Riêng</label>
                                <input type="number" step="0.01" name="price" class="form-control" placeholder="Để trống nếu lấy giá gốc">
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Link Ảnh Riêng (URL)</label>
                        <input type="text" name="image" class="form-control" placeholder="https://...">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng Thái</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE">Hoạt động</option>
                            <option value="INACTIVE">Ngừng bán</option>
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
<c:if test="${not empty editingSPCT}">
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cập Nhật Biến Thể / Tồn Kho</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/san-pham-chi-tiet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${editingSPCT.id}">
                <input type="hidden" name="productId" value="${productId}">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Màu Sắc</label>
                                <select name="colorId" class="form-select" required>
                                    <c:forEach var="ms" items="${listMauSac}">
                                        <option value="${ms.id}" ${ms.id == editingSPCT.colorId ? 'selected' : ''}>${ms.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Kích Thước</label>
                                <select name="sizeId" class="form-select" required>
                                    <c:forEach var="kt" items="${listKichThuoc}">
                                        <option value="${kt.id}" ${kt.id == editingSPCT.sizeId ? 'selected' : ''}>${kt.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mã Lưu Kho (SKU)</label>
                        <input type="text" name="sku" class="form-control" value="${editingSPCT.sku}" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Số Lượng Tồn</label>
                                <input type="number" name="quantity" class="form-control" value="${editingSPCT.quantity}" required min="0">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Giá Bán Riêng</label>
                                <input type="number" step="0.01" name="price" class="form-control" value="${editingSPCT.price}" placeholder="Để trống nếu lấy giá gốc">
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Link Ảnh Riêng (URL)</label>
                        <input type="text" name="image" class="form-control" value="${editingSPCT.image}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng Thái</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE" ${editingSPCT.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                            <option value="INACTIVE" ${editingSPCT.status == 'INACTIVE' ? 'selected' : ''}>Ngừng bán</option>
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