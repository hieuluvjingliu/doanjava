<jsp:include page="header.jsp">
    <jsp:param name="active" value="user" />
</jsp:include>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Quản Lý Người Dùng</h2>
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
                    <th>Họ Tên</th>
                    <th>Email</th>
                    <th>Điện Thoại</th>
                    <th>Vai Trò (Role)</th>
                    <th>Trạng Thái</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${listUser}">
                <tr>
                    <td>${u.id}</td>
                    <td>${u.fullName}</td>
                    <td>${u.email}</td>
                    <td>${u.phone}</td>
                    <td>
                        <span class="badge ${u.role == 'ADMIN' ? 'bg-danger' : (u.role == 'STAFF' ? 'bg-primary' : 'bg-secondary')}">${u.role}</span>
                    </td>
                    <td>
                        <span class="badge ${u.status == 'ACTIVE' ? 'bg-success' : 'bg-dark'}">${u.status}</span>
                    </td>
                    <td>
                        <button class="btn btn-sm btn-warning" onclick="editData(${u.id}, '${u.fullName}', '${u.phone}', '${u.address}', '${u.role}', '${u.status}')" data-bs-toggle="modal" data-bs-target="#editModal">Phân Quyền</button>
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
      <form action="user" method="post">
          <input type="hidden" name="action" value="add">
          <div class="modal-header">
            <h5 class="modal-title">Thêm Người Dùng</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
                <label>Họ Tên</label>
                <input type="text" name="fullName" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Email</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Mật Khẩu</label>
                <input type="text" name="password" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Điện Thoại</label>
                <input type="text" name="phone" class="form-control">
            </div>
            <div class="mb-3">
                <label>Địa Chỉ</label>
                <input type="text" name="address" class="form-control">
            </div>
            <div class="mb-3">
                <label>Vai Trò (Role)</label>
                <select name="role" class="form-select">
                    <option value="CUSTOMER">Khách Hàng</option>
                    <option value="STAFF">Nhân Viên</option>
                    <option value="ADMIN">Quản Trị Viên</option>
                </select>
            </div>
            <div class="mb-3">
                <label>Trạng Thái</label>
                <select name="status" class="form-select">
                    <option value="ACTIVE">Hoạt động</option>
                    <option value="INACTIVE">Khóa tài khoản</option>
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
      <form action="user" method="post">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="id" id="edit-id">
          <div class="modal-header">
            <h5 class="modal-title">Sửa Thông Tin / Phân Quyền</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
                <label>Họ Tên</label>
                <input type="text" name="fullName" id="edit-fullName" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Điện Thoại</label>
                <input type="text" name="phone" id="edit-phone" class="form-control">
            </div>
            <div class="mb-3">
                <label>Địa Chỉ</label>
                <input type="text" name="address" id="edit-address" class="form-control">
            </div>
            <div class="mb-3">
                <label>Vai Trò (Role)</label>
                <select name="role" id="edit-role" class="form-select">
                    <option value="CUSTOMER">Khách Hàng</option>
                    <option value="STAFF">Nhân Viên</option>
                    <option value="ADMIN">Quản Trị Viên</option>
                </select>
            </div>
            <div class="mb-3">
                <label>Trạng Thái</label>
                <select name="status" id="edit-status" class="form-select">
                    <option value="ACTIVE">Hoạt động</option>
                    <option value="INACTIVE">Khóa tài khoản</option>
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
    function editData(id, fullName, phone, address, role, status) {
        document.getElementById('edit-id').value = id;
        document.getElementById('edit-fullName').value = fullName;
        document.getElementById('edit-phone').value = phone;
        document.getElementById('edit-address').value = address;
        document.getElementById('edit-role').value = role;
        document.getElementById('edit-status').value = status;
    }
</script>

<jsp:include page="footer.jsp" />
