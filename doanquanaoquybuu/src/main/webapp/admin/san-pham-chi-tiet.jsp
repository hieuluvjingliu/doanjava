<jsp:include page="header.jsp">
    <jsp:param name="active" value="sanpham" />
</jsp:include>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Quản Lý Biến Thể (Size / Màu) cho Áo ID: ${productId}</h2>
    <div>
        <a href="san-pham" class="btn btn-secondary me-2"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
            <i class="fa-solid fa-plus"></i> Thêm Biến Thể
        </button>
    </div>
</div>

<c:if test="${not empty param.msg}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <strong>Thành công!</strong> Đã lưu thay đổi biến thể.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<div class="card shadow-sm">
    <div class="card-body">
        <table class="table table-hover table-bordered align-middle">
            <thead class="table-dark">
                <tr>
                    <th>SKU (Mã Kho)</th>
                    <th>Màu Sắc (ID)</th>
                    <th>Kích Thước (ID)</th>
                    <th>Giá Bán Riêng</th>
                    <th>Tồn Kho</th>
                    <th>Trạng Thái</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ct" items="${listSPCT}">
                <tr>
                    <td>${ct.sku}</td>
                    <td>${ct.colorId}</td>
                    <td>${ct.sizeId}</td>
                    <td>${ct.price == null ? 'Theo giá gốc' : ct.price}</td>
                    <td>${ct.quantity}</td>
                    <td>
                        <span class="badge ${ct.status == 'ACTIVE' ? 'bg-success' : 'bg-danger'}">${ct.status}</span>
                    </td>
                    <td>
                        <button class="btn btn-sm btn-warning" onclick="editData(${ct.id}, ${ct.colorId}, ${ct.sizeId}, '${ct.sku}', '${ct.price == null ? '' : ct.price}', ${ct.quantity}, '${ct.image}', '${ct.status}')" data-bs-toggle="modal" data-bs-target="#editModal">Sửa</button>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
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
                <label>Màu Sắc</label>
                <select name="colorId" class="form-select" required>
                    <c:forEach var="ms" items="${listMauSac}">
                        <option value="${ms.id}">${ms.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-6 mb-3">
                <label>Kích Thước (Size)</label>
                <select name="sizeId" class="form-select" required>
                    <c:forEach var="kt" items="${listKichThuoc}">
                        <option value="${kt.id}">${kt.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-12 mb-3">
                <label>Mã Lưu Kho (SKU)</label>
                <input type="text" name="sku" class="form-control" required>
            </div>
            <div class="col-6 mb-3">
                <label>Số Lượng Tồn</label>
                <input type="number" name="quantity" class="form-control" value="0" required>
            </div>
            <div class="col-6 mb-3">
                <label>Giá Bán Riêng (Bỏ trống nếu lấy giá gốc)</label>
                <input type="number" step="0.01" name="price" class="form-control">
            </div>
            <div class="col-12 mb-3">
                <label>Link Ảnh Riêng (Ngoại lệ)</label>
                <input type="text" name="image" class="form-control">
            </div>
            <div class="col-12 mb-3">
                <label>Trạng Thái</label>
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
            <h5 class="modal-title">Cập Nhật Biến Thể</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body row">
            <div class="col-6 mb-3">
                <label>Màu Sắc</label>
                <select name="colorId" id="edit-colorId" class="form-select" required>
                    <c:forEach var="ms" items="${listMauSac}">
                        <option value="${ms.id}">${ms.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-6 mb-3">
                <label>Kích Thước (Size)</label>
                <select name="sizeId" id="edit-sizeId" class="form-select" required>
                    <c:forEach var="kt" items="${listKichThuoc}">
                        <option value="${kt.id}">${kt.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-12 mb-3">
                <label>Mã Lưu Kho (SKU)</label>
                <input type="text" name="sku" id="edit-sku" class="form-control" required>
            </div>
            <div class="col-6 mb-3">
                <label>Số Lượng Tồn</label>
                <input type="number" name="quantity" id="edit-quantity" class="form-control" required>
            </div>
            <div class="col-6 mb-3">
                <label>Giá Bán Riêng (Bỏ trống nếu lấy giá gốc)</label>
                <input type="number" step="0.01" name="price" id="edit-price" class="form-control">
            </div>
            <div class="col-12 mb-3">
                <label>Link Ảnh Riêng</label>
                <input type="text" name="image" id="edit-image" class="form-control">
            </div>
            <div class="col-12 mb-3">
                <label>Trạng Thái</label>
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
