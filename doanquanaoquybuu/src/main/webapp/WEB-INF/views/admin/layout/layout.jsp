<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - QUYBUU Store</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendors/perfect-scrollbar/perfect-scrollbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendors/bootstrap-icons/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.svg" type="image/x-icon">
    <style>
        .qb-flash-container{position:fixed;top:80px;right:20px;z-index:9999;min-width:300px;max-width:420px;}
        .qb-flash-container .alert{margin-bottom:10px;box-shadow:0 4px 12px rgba(0,0,0,.12);border-radius:8px;border:none;}
        .pagination .page-link{color:#435ebe;}
        .pagination .page-item.active .page-link{background-color:#435ebe;border-color:#435ebe;}
    </style>
</head>

<body>
    <%
        String flashSuccess = (String) request.getSession().getAttribute("flashSuccess");
        String flashError   = (String) request.getSession().getAttribute("flashError");
        if (flashSuccess != null) { session.removeAttribute("flashSuccess"); }
        if (flashError != null)   { session.removeAttribute("flashError"); }
    %>
    <div class="qb-flash-container">
        <c:if test="${not empty flashSuccess}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-1"></i> ${flashSuccess}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty flashError}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle me-1"></i> ${flashError}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
    </div>

    <div id="app">
        <div id="sidebar" class="active">
            <div class="sidebar-wrapper active">
                <div class="sidebar-header">
                    <div class="d-flex justify-content-between">
                        <div class="logo">
                            <a href="${pageContext.request.contextPath}/admin/dashboard">
                                <img src="${pageContext.request.contextPath}/assets/images/logo/logo.png" alt="Logo" srcset="">
                            </a>
                        </div>
                        <div class="toggler">
                            <a href="#" class="sidebar-hide d-xl-none d-block"><i class="bi bi-x bi-middle"></i></a>
                        </div>
                    </div>
                </div>
                <div class="sidebar-menu">
                    <ul class="menu">
                        <li class="sidebar-title">Quản Lý</li>

                        <li class="sidebar-item">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class='sidebar-link'>
                                <i class="bi bi-grid-fill"></i>
                                <span>Dashboard</span>
                            </a>
                        </li>

                        <li class="sidebar-item">
                            <a href="${pageContext.request.contextPath}/admin/orders" class='sidebar-link'>
                                <i class="bi bi-receipt"></i>
                                <span>Đơn Hàng</span>
                            </a>
                        </li>

                        <li class="sidebar-item">
                            <a href="${pageContext.request.contextPath}/admin/products" class='sidebar-link'>
                                <i class="bi bi-box-seam"></i>
                                <span>Sản Phẩm</span>
                            </a>
                        </li>

                        <li class="sidebar-item">
                            <a href="${pageContext.request.contextPath}/admin/danh-muc" class='sidebar-link'>
                                <i class="bi bi-bookmark-fill"></i>
                                <span>Danh Mục</span>
                            </a>
                        </li>

                        <li class="sidebar-item">
                            <a href="${pageContext.request.contextPath}/admin/kich-thuoc" class='sidebar-link'>
                                <i class="bi bi-rulers"></i>
                                <span>Kích Thước</span>
                            </a>
                        </li>

                        <li class="sidebar-item">
                            <a href="${pageContext.request.contextPath}/admin/mau-sac" class='sidebar-link'>
                                <i class="bi bi-palette"></i>
                                <span>Màu Sắc</span>
                            </a>
                        </li>

                        <li class="sidebar-item">
                            <a href="${pageContext.request.contextPath}/admin/users" class='sidebar-link'>
                                <i class="bi bi-people-fill"></i>
                                <span>Người Dùng</span>
                            </a>
                        </li>

                        <li class="sidebar-title mt-4">Hệ Thống</li>

                        <li class="sidebar-item">
                            <a href="${pageContext.request.contextPath}/trang-chu" class='sidebar-link' target="_blank">
                                <i class="bi bi-globe"></i>
                                <span>Xem Website</span>
                            </a>
                        </li>

                        <li class="sidebar-item">
                            <a href="${pageContext.request.contextPath}/login?action=logout" class='sidebar-link'>
                                <i class="bi bi-box-arrow-right"></i>
                                <span>Đăng Xuất</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        
        <div id="main">
            <nav class="navbar navbar-expand navbar-light ">
                <div class="container-fluid">
                    <a href="#" class="sidebar-burger-toggler d-xl-none d-block">
                        <i class="bi bi-justify fs-3"></i>
                    </a>
                </div>
            </nav>
            
            <main class="admin-main">
                <jsp:include page="${contentPage}" />
            </main>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/vendors/perfect-scrollbar/perfect-scrollbar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/simple-datatables/simple-datatables.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>

</html>
