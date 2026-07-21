<jsp:include page="header.jsp">
    <jsp:param name="active" value="kichthuoc" />
</jsp:include>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Quản Lý Kích Thước</h2>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
        <i class="fa-solid fa-plus"></i> Thêm Mới
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
                    <th>ID</th>
                    <th>Tên Kích Thước</th>
                    <th>Thứ tự (Sort)</th>
                    <th>Trạng Thái</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="kt" items="${listKichThuoc}">
                <tr>
                    <td>${kt.id}</td>
                    <td>${kt.name}</td>
                    <td>${kt.sortOrder}</td>
                    <td>
                        <span class="badge ${kt.status == 'ACTIVE' ? 'bg-success' : 'bg-danger'}">${kt.status}</span>
                    </td>
                    <td>
                        <button class="btn btn-sm btn-warning" onclick="editData(${kt.id}, '${kt.name}', ${kt.sortOrder}, '${kt.status}')" data-bs-toggle="modal" data-bs-target="#editModal">Sửa</button>
                        <a href="kich-thuoc?action=delete&id=${kt.id}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa?')">Xóa</a>
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
      <form action="kich-thuoc" method="post">
          <input type="hidden" name="action" value="add">
          <div class="modal-header">
            <h5 class="modal-title">Thêm Kích Thước</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
                <label>Tên Kích Thước</label>
                <input type="text" name="name" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Thứ tự hiển thị (Sort Order)</label>
                <input type="number" name="sortOrder" class="form-control" value="0" required>
            </div>
            <div class="mb-3">
                <label>Trạng Thái</label>
                <select name="status" class="form-select">
                    <option value="ACTIVE">Hoạt động</option>
                    <option value="INACTIVE">Không hoạt động</option>
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
      <form action="kich-thuoc" method="post">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="id" id="edit-id">
          <div class="modal-header">
            <h5 class="modal-title">Cập Nhật Kích Thước</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
                <label>Tên Kích Thước</label>
                <input type="text" name="name" id="edit-name" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Thứ tự hiển thị (Sort Order)</label>
                <input type="number" name="sortOrder" id="edit-sortOrder" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Trạng Thái</label>
                <select name="status" id="edit-status" class="form-select">
                    <option value="ACTIVE">Hoạt động</option>
                    <option value="INACTIVE">Không hoạt động</option>
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
    function editData(id, name, sortOrder, status) {
        document.getElementById('edit-id').value = id;
        document.getElementById('edit-name').value = name;
        document.getElementById('edit-sortOrder').value = sortOrder;
        document.getElementById('edit-status').value = status;
    }
</script>

<jsp:include page="footer.jsp" />
