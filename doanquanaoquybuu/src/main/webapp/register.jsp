<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<style>
    .login-container { max-width: 520px; margin: 50px auto; padding: 36px 40px; border-radius: 12px; box-shadow: 0 4px 24px rgba(0,0,0,0.08); background: #fff;}
    .login-title { font-size: 24px; font-weight: 700; text-align: center; margin-bottom: 6px; letter-spacing: 0.5px;}
    .login-subtitle { text-align: center; color: #888; margin-bottom: 24px; font-size: 14px;}
    .form-group { margin-bottom: 16px; }
    .form-label { font-weight: 600; font-size: 13px; margin-bottom: 5px; display: block;}
    .form-control { border-radius: 6px; padding: 10px 14px; border: 1px solid #ddd;}
    .form-control:focus { border-color: #435ebe; box-shadow: 0 0 0 0.15rem rgba(67, 94, 190, 0.12);}
    .form-control.is-invalid { border-color: #dc3545;}
    .invalid-feedback { font-size: 13px; margin-top: 4px;}
    .btn-register { background-color: #435ebe; color: #fff; border: none; padding: 12px; width: 100%; font-size: 15px; font-weight: 600; border-radius: 6px; transition: 0.2s;}
    .btn-register:hover { background-color: #364b9c;}
    .form-hint { font-size: 13px; color: #888;}
    .form-hint a { color: #435ebe; text-decoration: none;}
    .form-hint a:hover { text-decoration: underline;}
    .row-2col { display: grid; grid-template-columns: 1fr 1fr; gap: 14px;}
</style>

<div class="container">
    <div class="login-container">
        <h2 class="login-title">ĐĂNG KÝ TÀI KHOẢN</h2>
        <p class="login-subtitle">Tạo tài khoản để mua sắm và nhận nhiều ưu đãi</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle me-1"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="register" method="post" class="needs-validation" novalidate>
            <div class="form-group">
                <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A"
                       value="<c:out value='${enteredFullName}'/>" required minlength="2" maxlength="100">
            </div>
            <div class="row-2col">
                <div class="form-group">
                    <label class="form-label">Email <span class="text-danger">*</span></label>
                    <input type="email" name="email" class="form-control" placeholder="email@example.com"
                           value="<c:out value='${enteredEmail}'/>" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Số điện thoại</label>
                    <input type="tel" name="phone" class="form-control" placeholder="0912345678"
                           pattern="(0[3-9])[0-9]{8}" value="<c:out value='${enteredPhone}'/>">
                    <div class="form-hint">Định dạng: 0912345678</div>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Địa chỉ</label>
                <input type="text" name="address" class="form-control" placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành"
                       value="<c:out value='${enteredAddress}'/>">
            </div>
            <div class="form-group">
                <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                <input type="password" name="password" class="form-control" placeholder="Tối thiểu 6 ký tự"
                       required minlength="6">
                <div class="form-hint">Mật khẩu phải có ít nhất 6 ký tự.</div>
            </div>
            <button type="submit" class="btn-register">ĐĂNG KÝ</button>
            <div class="text-center mt-3 form-hint">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
            </div>
        </form>
    </div>
</div>

<script>
// Bootstrap client-side validation feedback
(function () {
    'use strict';
    var forms = document.querySelectorAll('.needs-validation');
    Array.prototype.slice.call(forms).forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
})();
</script>

<jsp:include page="footer.jsp" />
