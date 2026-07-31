<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<style>
    .login-container { max-width: 500px; margin: 60px auto; padding: 40px; border-radius: 10px; box-shadow: 0 0 20px rgba(0,0,0,0.05); background: #fff;}
    .login-title { font-size: 28px; font-weight: bold; text-align: center; margin-bottom: 30px; letter-spacing: 1px;}
    .form-group { margin-bottom: 20px; }
    .form-control { border-radius: 5px; padding: 12px 15px; }
    .btn-login { background-color: #000; color: #fff; border: none; padding: 15px; width: 100%; font-size: 16px; font-weight: bold; border-radius: 5px; transition: 0.3s;}
    .btn-login:hover { background-color: #333; }
</style>

<div class="container">
    <div class="login-container">
        <h2 class="login-title">ĐĂNG KÝ TÀI KHOẢN</h2>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <form action="register" method="post">
            <div class="form-group mb-3">
                <label class="mb-2 fw-bold">Họ và tên</label>
                <input type="text" name="fullName" class="form-control" placeholder="Nhập họ và tên..." required>
            </div>
            <div class="form-group mb-3">
                <label class="mb-2 fw-bold">Email của bạn</label>
                <input type="email" name="email" class="form-control" placeholder="Nhập email..." required>
            </div>
            <div class="form-group mb-3">
                <label class="mb-2 fw-bold">Số điện thoại</label>
                <input type="text" name="phone" class="form-control" placeholder="Nhập số điện thoại...">
            </div>
            <div class="form-group mb-3">
                <label class="mb-2 fw-bold">Địa chỉ</label>
                <input type="text" name="address" class="form-control" placeholder="Nhập địa chỉ...">
            </div>
            <div class="form-group mb-4">
                <label class="mb-2 fw-bold">Mật khẩu</label>
                <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu..." required>
            </div>
            <button type="submit" class="btn-login">ĐĂNG KÝ</button>
            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/login" class="text-secondary text-decoration-none">Đã có tài khoản? Đăng nhập ngay</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />
