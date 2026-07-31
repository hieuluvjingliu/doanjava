<jsp:include page="header.jsp">
    <jsp:param name="active" value="sanpham" />
</jsp:include>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .qb-stock-badge {
        display: inline-block;
        padding: 3px 10px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
        min-width: 50px;
        text-align: center;
    }
    .qb-stock-empty { background: #fde2e2; color: #b91c1c; }
    .qb-stock-low   { background: #fff3cd; color: #92400e; }
    .qb-stock-ok    { background: #d1fae5; color: #065f46; }
    .qb-add-size-row {
        background: #f8f9fa;
        padding: 10px 14px;
        border-radius: 8px;
        margin-bottom: 12px;
    }
</style>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2 class="mb-0"><i class="fa-solid fa-boxes-stacked"></i> Quản Lý Tồn Kho / Biến Thể</h2>
    <div>
        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary me-2"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
        <a href="${pageContext.request.contextPath}/admin/kich-thuoc" target="_blank" class="btn btn-outline-secondary me-2"><i class="fa-solid fa-ruler"></i> Quản Lý Size</a>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
            <i class="fa-solid fa-plus"></i> Thêm Biến Thể
        </button>
    </div>
</div>

<div class="alert alert-light border">
    <strong>Sản phẩm ID: ${productId}</strong> &mdash; Quản lý từng biến thể (màu + size + tồn kho) ở đây.
</div>

<c:if test="${not empty param.msg}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <strong>Thành công!</strong> Đã lưu thay đổi biến thể.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'size_added'}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <strong>Thành công!</strong> Đã thêm kích thước mới.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
<c:if test="${param.err == 'duplicate_size'}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <strong>Trùng!</strong> Kích thước này đã tồn tại trong hệ thống.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<!-- Thêm nhanh size ngay tại trang -->
<div class="qb-add-size-row d-flex align-items-center gap-2">
    <span class="me-2"><i class="fa-solid fa-bolt text-warning"></i> <strong>Thêm nhanh Size:</strong></span>
    <form action="${pageContext.request.contextPath}/admin/kich-thuoc" method="post" class="d-flex gap-2 flex-grow-1" id="quickSizeForm">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="returnTo" value="/admin/san-pham-chi-tiet?productId=${productId}">
        <input type="text" name="name" class="form-control form-control-sm" placeholder="Tên size (vd: XXL, 39, Free Size)" required maxlength="20" style="max-width: 240px;">
        <input type="number" name="sortOrder" class="form-control form-control-sm" placeholder="Thứ tự" value="10" style="max-width: 100px;">
        <select name="status" class="form-select form-select-sm" style="max-width: 130px;">
            <option value="ACTIVE">Hoạt động</option>
            <option value="INACTIVE">Ngừng dùng</option>
        </select>
        <button type="submit" class="btn btn-warning btn-sm"><i class="fa-solid fa-plus"></i> Thêm Size</button>
    </form>
</div>

<div class="card shadow-sm">
    <div class="card-body">
        <c:choose>
            <c:when test="${empty listSPCT}">
                <div class="text-center text-muted py-5">
                    <i class="fa-solid fa-box-open fa-3x mb-3"></i>
                    <p>Chưa có biến thể nào. Click <strong>"Thêm Biến Thể"</strong> ở trên để bắt đầu.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>SKU (Mã Kho)</th>
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
                                    <c:when test="${ct.price == null}"><span class="text-muted">Theo giá gốc</span></c:when>
                                    <c:otherwise><fmt:formatNumber value="${ct.price}" pattern="#,###"/> ₫</c:otherwise>
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
                                <span class="badge ${ct.status == 'ACTIVE' ? 'bg-success' : 'bg-danger'}">${ct.status == 'ACTIVE' ? 'Hoạt động' : 'Ngừng bán'}</span>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-warning" onclick="editData(${ct.id}, ${ct.colorId}, ${ct.sizeId}, '${ct.sku}', '${ct.price == null ? '' : ct.price}', ${ct.quantity}, '${ct.image}', '${ct.status}')" data-bs-toggle="modal" data-bs-target="#editModal">
                                    <i class="fa-solid fa-pen"></i> Sửa
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/san-pham-chi-tiet?action=delete&id=${ct.id}&productId=${productId}" class="btn btn-sm btn-danger" onclick="return confirm('Xóa biến thể này?')">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Add Modal -->
<div class="modal fade" id="addModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form action="san-pham-chi-tiet" method="post">
          <input type="hidden" name="action" value="add">
          <input type="hidden" name="productId" value="${productId}">

          <div class="modal-header">
            <h5 class="modal-title">Thêm Biến Thể</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body row">
            <div class="col-6 mb-3">
                <label class="form-label">Màu Sắc</label>
                <select name="colorId" class="form-select" required>
                    <c:forEach var="ms" items="${listMauSac}">
                        <option value="${ms.id}">${ms.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-6 mb-3">
                <label class="form-label">Kích Thước (Size)</label>
                <select name="sizeId" class="form-select" required>
                    <c:forEach var="kt" items="${listKichThuoc}">
                        <option value="${kt.id}">${kt.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Mã Lưu Kho (SKU)</label>
                <input type="text" name="sku" class="form-control" required>
            </div>
            <div class="col-6 mb-3">
                <label class="form-label"><i class="fa-solid fa-cubes"></i> Số Lượng Tồn</label>
                <input type="number" name="quantity" class="form-control" value="0" required min="0">
            </div>
            <div class="col-6 mb-3">
                <label class="form-label">Giá Bán Riêng (Bỏ trống nếu lấy giá gốc)</label>
                <input type="number" step="0.01" name="price" class="form-control">
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Link Ảnh Riêng (Ngoại lệ)</label>
                <input type="text" name="image" class="form-control">
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Trạng Thái</label>
                <select name="status" class="form-select">
                    <option value="ACTIVE">Hoạt động</option>
                    <option value="INACTIVE">Ngừng bán</option>
                </select>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            <button type="submit" class="btn btn-primary">Lưu Lại</button>
          </div>
      </form>
    </div>
  </div>
</div>

<!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form action="san-pham-chi-tiet" method="post">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="id" id="edit-id">
          <input type="hidden" name="productId" value="${productId}">

          <div class="modal-header">
            <h5 class="modal-title">Cập Nhật Biến Thể / Tồn Kho</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body row">
            <div class="col-6 mb-3">
                <label class="form-label">Màu Sắc</label>
                <select name="colorId" id="edit-colorId" class="form-select" required>
                    <c:forEach var="ms" items="${listMauSac}">
                        <option value="${ms.id}">${ms.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-6 mb-3">
                <label class="form-label">Kích Thước (Size)</label>
                <select name="sizeId" id="edit-sizeId" class="form-select" required>
                    <c:forEach var="kt" items="${listKichThuoc}">
                        <option value="${kt.id}">${kt.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Mã Lưu Kho (SKU)</label>
                <input type="text" name="sku" id="edit-sku" class="form-control" required>
            </div>
            <div class="col-6 mb-3">
                <label class="form-label"><i class="fa-solid fa-cubes"></i> Số Lượng Tồn</label>
                <input type="number" name="quantity" id="edit-quantity" class="form-control" required min="0">
            </div>
            <div class="col-6 mb-3">
                <label class="form-label">Giá Bán Riêng</label>
                <input type="number" step="0.01" name="price" id="edit-price" class="form-control">
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Link Ảnh Riêng</label>
                <input type="text" name="image" id="edit-image" class="form-control">
            </div>
            <div class="col-12 mb-3">
                <label class="form-label">Trạng Thái</label>
                <select name="status" id="edit-status" class="form-select">
                    <option value="ACTIVE">Hoạt động</option>
                    <option value="INACTIVE">Ngừng bán</option>
                </select>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            <button type="submit" class="btn btn-warning">Cập Nhật</button>
          </div>
      </form>
    </div>
  </div>
</div>

<script>
    function editData(id, colorId, sizeId, sku, price, qty, img, status) {
        document.getElementById('edit-id').value = id;
        document.getElementById('edit-colorId').value = colorId;
        document.getElementById('edit-sizeId').value = sizeId;
        document.getElementById('edit-sku').value = sku;
        document.getElementById('edit-price').value = price;
        document.getElementById('edit-quantity').value = qty;
        document.getElementById('edit-image').value = img;
        document.getElementById('edit-status').value = status;
    }
</script>

<jsp:include page="footer.jsp" />