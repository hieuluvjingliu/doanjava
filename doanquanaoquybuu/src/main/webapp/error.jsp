<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đã xảy ra lỗi - QUYBUU Store</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .error-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            padding: 48px;
            max-width: 640px;
            margin: 0 auto;
        }
        .error-icon {
            font-size: 96px;
            color: #ef4444;
            line-height: 1;
        }
        .error-code {
            font-size: 64px;
            font-weight: 800;
            color: #1f2937;
            margin: 0;
        }
        .error-help {
            background: #f3f4f6;
            border-left: 4px solid #435ebe;
            padding: 12px 16px;
            margin-top: 16px;
            border-radius: 4px;
            font-size: 14px;
            color: #4b5563;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-card text-center">
            <i class="bi bi-exclamation-triangle-fill error-icon"></i>
            <h1 class="error-code mt-3">${statusCode != null ? statusCode : 500}</h1>
            <h4 class="text-muted mb-3">Đã xảy ra lỗi</h4>
            <p class="text-muted">
                Hệ thống gặp sự cố trong quá trình xử lý yêu cầu của bạn.
            </p>
            <c:if test="${not empty errorMessage}">
                <div class="error-help text-start">
                    <strong><i class="bi bi-bug"></i> Chi tiết:</strong><br>
                    <code>${errorMessage}</code>
                </div>
            </c:if>
            <c:if test="${not empty requestUri}">
                <div class="error-help text-start">
                    <strong><i class="bi bi-link-45deg"></i> Đường dẫn:</strong><br>
                    <code>${requestUri}</code>
                </div>
            </c:if>
            <div class="mt-4 d-flex gap-2 justify-content-center">
                <a href="${pageContext.request.contextPath}/trang-chu" class="btn btn-primary">
                    <i class="bi bi-house"></i> Về trang chủ
                </a>
                <button onclick="history.back()" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </button>
            </div>
        </div>
    </div>
</body>
</html>
