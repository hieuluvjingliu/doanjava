<jsp:include page="header.jsp">
    <jsp:param name="active" value="sanpham" />
</jsp:include>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Quản Lý Sản Phẩm (Mẫu Áo)</h2>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
        <i class="fa-solid fa-plus"></i> Thêm Áo Mới
    </button>
</div>

<c:if test="${not empty param.msg}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <strong>Thành công!</strong> Thao tác đã được thực hiện.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<div class="card shadow-sm">
    <div class="card-body">
        <table class="table table-hover table-bordered align-middle">
            <thead class="table-dark">
                <tr>
                    <th>Ảnh</th>
                    <th>Tên Sản Phẩm</th>
                    <th>Danh Mục (ID)</th>
                    <th>Giá Gốc</th>
                    <th>Trạng Thái</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="sp" items="${listSanPham}">
                <tr>
                    <td>
                        <c:if test="${not empty sp.image}">
                            <img src="${pageContext.request.contextPath}/${sp.image}" alt="ảnh" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px;">
                        </c:if>
                    </td>
                    <td>${sp.name}</td>
                    <td>${sp.categoryId}</td>
                    <td>${sp.basePrice} VNĐ</td>
                    <td>
                        <span class="badge ${sp.status == 'ACTIVE' ? 'bg-success' : 'bg-danger'}">${sp.status}</span>
                    </td>
                    <td>
                        <a href="san-pham-chi-tiet?productId=${sp.id}" class="btn btn-sm btn-info text-white">Biến Thể</a>
                        <button class="btn btn-sm btn-warning" onclick="editData(${sp.id}, ${sp.categoryId}, '${sp.name}', '${sp.description}', ${sp.basePrice}, '${sp.image}', '${sp.status}')" data-bs-toggle="modal" data-bs-target="#editModal">Sửa</button>
                        <a href="san-pham?action=delete&id=${sp.id}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa?')">Xóa</a>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Add Modal -->
<div class="modal fade" id="addModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <!-- Phải có enctype multipart/form-data để upload ảnh -->
      <form action="san-pham" method="post" enctype="multipart/form-data">
          <input type="hidden" name="action" value="add">
          <div class="modal-header">
            <h5 class="modal-title">Thêm Sản Phẩm Mới</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body row">
            <div class="col-md-6 mb-3">
                <label>Tên Sản Phẩm</label>
                <input type="text" name="name" class="form-control" required>
            </div>
            <div class="col-md-6 mb-3">
                <label>Danh Mục</label>
                <select name="categoryId" class="form-select" required>
                    <option value="">-- Chọn danh mục --</option>
                    <c:forEach var="dm" items="${listDanhMuc}">
                        <option value="${dm.id}">${dm.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-6 mb-3">
                <label>Giá Gốc</label>
                <input type="number" name="basePrice" class="form-control" value="0" required>
            </div>
            <div class="col-md-6 mb-3">
                <label>Trạng Thái</label>
                <select name="status" class="form-select">
                    <option value="ACTIVE">Hoạt động</option>
                    <option value="INACTIVE">Không hoạt động</option>
                </select>
            </div>
            <div class="col-12 mb-3">
                <label>Mô Tả</label>
                <textarea name="description" class="form-control" rows="3"></textarea>
            </div>
            <div class="col-12 mb-3">
                <label>Ảnh Sản Phẩm</label>
                <input type="file" name="imageFile" class="form-control" accept="image/*">
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
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="san-pham" method="post" enctype="multipart/form-data">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="id" id="edit-id">
          <input type="hidden" name="oldImage" id="edit-oldImage">
          
          <div class="modal-header">
            <h5 class="modal-title">Cập Nhật Sản Phẩm</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body row">
            <div class="col-md-6 mb-3">
                <label>Tên Sản Phẩm</label>
                <input type="text" name="name" id="edit-name" class="form-control" required>
            </div>
            <div class="col-md-6 mb-3">
                <label>Danh Mục</label>
                <select name="categoryId" id="edit-categoryId" class="form-select" required>
                    <c:forEach var="dm" items="${listDanhMuc}">
                        <option value="${dm.id}">${dm.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-6 mb-3">
                <label>Giá Gốc</label>
                <input type="number" name="basePrice" id="edit-basePrice" class="form-control" required>
            </div>
            <div class="col-md-6 mb-3">
                <label>Trạng Thái</label>
                <select name="status" id="edit-status" class="form-select">
                    <option value="ACTIVE">Hoạt động</option>
                    <option value="INACTIVE">Không hoạt động</option>
                </select>
            </div>
            <div class="col-12 mb-3">
                <label>Mô Tả</label>
                <textarea name="description" id="edit-description" class="form-control" rows="3"></textarea>
            </div>
            <div class="col-12 mb-3">
                <label>Thay Ảnh Mới (Để trống nếu muốn giữ nguyên)</label>
                <input type="file" name="imageFile" class="form-control" accept="image/*">
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
    function editData(id, catId, name, desc, price, img, status) {
        document.getElementById('edit-id').value = id;
        document.getElementById('edit-categoryId').value = catId;
        document.getElementById('edit-name').value = name;
        document.getElementById('edit-description').value = desc;
        document.getElementById('edit-basePrice').value = price;
        document.getElementById('edit-oldImage').value = img;
        document.getElementById('edit-status').value = status;
    }
</script>

<jsp:include page="footer.jsp" />
