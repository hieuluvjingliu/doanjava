<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<style>
    .login-container { max-width: 460px; margin: 60px auto; padding: 40px; border-radius: 12px; box-shadow: 0 4px 24px rgba(0,0,0,0.08); background: #fff;}
    .login-title { font-size: 26px; font-weight: 700; text-align: center; margin-bottom: 8px; letter-spacing: 0.5px;}
    .login-subtitle { text-align: center; color: #888; margin-bottom: 28px; font-size: 14px;}
    .form-group { margin-bottom: 18px; }
    .form-label { font-weight: 600; font-size: 14px; margin-bottom: 6px; display: block;}
    .form-control { border-radius: 6px; padding: 11px 14px; border: 1px solid #ddd;}
    .form-control:focus { border-color: #435ebe; box-shadow: 0 0 0 0.15rem rgba(67, 94, 190, 0.12);}
    .form-control.is-invalid { border-color: #dc3545;}
    .invalid-feedback { font-size: 13px; margin-top: 4px;}
    .btn-login { background-color: #435ebe; color: #fff; border: none; padding: 13px; width: 100%; font-size: 15px; font-weight: 600; border-radius: 6px; transition: 0.2s;}
    .btn-login:hover { background-color: #364b9c;}
    .form-hint { font-size: 13px; color: #888;}
    .form-hint a { color: #435ebe; text-decoration: none;}
    .form-hint a:hover { text-decoration: underline;}
</style>

<div class="container">
    <div class="login-container">
        <h2 class="login-title">ĐĂNG NHẬP</h2>
        <p class="login-subtitle">Chào mừng bạn quay lại với QUYBUU Store</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle me-1"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'register_success'}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle me-1"></i> Đăng ký thành công! Vui lòng đăng nhập.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="login" method="post" class="needs-validation" novalidate>
            <div class="form-group">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" placeholder="email@example.com"
                       value="<c:out value='${enteredEmail}'/>" required>
            </div>
            <div class="form-group">
                <label class="form-label">Mật khẩu</label>
                <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu..." required>
            </div>
            <button type="submit" class="btn-login">ĐĂNG NHẬP</button>
            <div class="text-center mt-3 form-hint">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />
