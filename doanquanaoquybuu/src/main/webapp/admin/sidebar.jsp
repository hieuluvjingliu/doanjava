<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="col-md-2 sidebar d-flex flex-column">
    <h4 class="text-center mb-4"><i class="fa-solid fa-store"></i> Quý Bửu</h4>
    <hr class="text-secondary">
    <a href="${pageContext.request.contextPath}/admin/danh-muc" class="${param.active == 'danhmuc' ? 'active' : ''}"><i class="fa-solid fa-list"></i> Danh Mục</a>
    <a href="${pageContext.request.contextPath}/admin/mau-sac" class="${param.active == 'mausac' ? 'active' : ''}"><i class="fa-solid fa-palette"></i> Màu Sắc</a>
    <a href="${pageContext.request.contextPath}/admin/kich-thuoc" class="${param.active == 'kichthuoc' ? 'active' : ''}"><i class="fa-solid fa-ruler"></i> Kích Thước</a>
    <a href="${pageContext.request.contextPath}/admin/san-pham" class="${param.active == 'sanpham' ? 'active' : ''}"><i class="fa-solid fa-shirt"></i> Sản Phẩm</a>
    <a href="${pageContext.request.contextPath}/admin/user" class="${param.active == 'user' ? 'active' : ''}"><i class="fa-solid fa-users"></i> Người Dùng</a>
    <hr class="text-secondary mt-auto">
    <a href="${pageContext.request.contextPath}/logout" class="text-danger"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
</div>
<!-- Kết thúc Sidebar -->
<div class="col-md-10 content-area">
