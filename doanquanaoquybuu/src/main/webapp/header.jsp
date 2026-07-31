<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="service.CartService" %>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Quý Bửu - Đồ Cosplay & Anime chính hãng: Áo thun Anime, Áo Hoodie, Cosplay & Phụ kiện. Hàng chất lượng, giao hàng toàn quốc.">
    <meta name="keywords" content="cosplay, anime, áo thun anime, hoodie anime, áo khoác cosplay, phụ kiện anime, quý bửu">
    <title>Quý Bửu - Đồ Cosplay & Anime Chính Hãng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --qb-primary: #d62828;
            --qb-primary-dark: #b71c1c;
            --qb-text: #222;
            --qb-muted: #666;
            --qb-bg: #ffffff;
            --qb-border: #eee;
            --qb-header-h: 64px;
        }
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            color: var(--qb-text);
            margin: 0;
            background: #fafafa;
        }
        a { text-decoration: none; color: inherit; }

        .qb-header {
            background: var(--qb-bg);
            border-bottom: 1px solid var(--qb-border);
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .qb-topbar {
            background: #111;
            color: #fff;
            font-size: 13px;
            padding: 6px 0;
            text-align: center;
        }
        .qb-topbar .bi { color: #ffeb3b; }

        .qb-navbar {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 24px;
            height: var(--qb-header-h);
            display: flex;
            align-items: center;
            gap: 32px;
        }
        .qb-logo {
            font-size: 22px;
            font-weight: 800;
            letter-spacing: 1px;
            color: var(--qb-primary);
            white-space: nowrap;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .qb-logo .bi-fire { font-size: 26px; }
        .qb-logo small {
            font-size: 10px;
            font-weight: 500;
            color: var(--qb-muted);
            letter-spacing: 2px;
            display: block;
            margin-top: -4px;
        }

        .qb-menu {
            display: flex;
            align-items: center;
            gap: 28px;
            list-style: none;
            padding: 0;
            margin: 0;
            flex: 1;
        }
        .qb-menu > li > a {
            color: var(--qb-text);
            font-weight: 600;
            font-size: 15px;
            padding: 8px 0;
            position: relative;
            transition: color .15s;
        }
        .qb-menu > li > a:hover { color: var(--qb-primary); }
        .qb-menu > li > a::after {
            content: '';
            position: absolute;
            left: 0; bottom: 0;
            width: 0; height: 2px;
            background: var(--qb-primary);
            transition: width .2s;
        }
        .qb-menu > li > a:hover::after { width: 100%; }

        .qb-dropdown { position: relative; }
        .qb-dropdown-toggle .bi-chevron-down { font-size: 11px; margin-left: 4px; }
        .qb-dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            background: #fff;
            min-width: 220px;
            border: 1px solid var(--qb-border);
            border-radius: 6px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            padding: 8px 0;
            list-style: none;
            margin: 0;
            opacity: 0;
            visibility: hidden;
            transform: translateY(6px);
            transition: all .15s;
            z-index: 1100;
        }
        .qb-dropdown:hover .qb-dropdown-menu {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }
        .qb-dropdown-menu li a {
            display: block;
            padding: 8px 18px;
            color: var(--qb-text);
            font-size: 14px;
            transition: background .12s;
        }
        .qb-dropdown-menu li a:hover {
            background: #fef0f0;
            color: var(--qb-primary);
        }

        .qb-actions {
            display: flex;
            align-items: center;
            gap: 4px;
            margin-left: auto;
        }
        .qb-icon-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: none;
            background: transparent;
            color: var(--qb-text);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            position: relative;
            cursor: pointer;
            transition: background .15s;
        }
        .qb-icon-btn:hover { background: #f3f3f3; color: var(--qb-primary); }
        .qb-icon-btn .bi { font-size: 20px; }
        .qb-badge {
            position: absolute;
            top: 4px; right: 4px;
            min-width: 18px;
            height: 18px;
            padding: 0 5px;
            background: var(--qb-primary);
            color: #fff;
            border-radius: 9px;
            font-size: 11px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            line-height: 1;
        }

        .qb-search {
            position: relative;
            margin-left: 4px;
        }
        .qb-search input {
            width: 0;
            padding: 0;
            border: 1px solid transparent;
            border-radius: 20px;
            transition: width .25s, padding .25s, border-color .25s;
            outline: none;
            font-size: 14px;
        }
        .qb-search.open input {
            width: 220px;
            padding: 8px 14px 8px 36px;
            border-color: #ddd;
        }
        .qb-search .bi-search {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--qb-muted);
            pointer-events: none;
        }

        .qb-user {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 20px;
            border: 1px solid transparent;
            transition: border-color .15s;
        }
        .qb-user:hover { border-color: #ddd; }
        .qb-user-logout { color: var(--qb-primary); }

        .qb-burger {
            display: none;
            background: transparent;
            border: none;
            font-size: 24px;
            cursor: pointer;
        }

        @media (max-width: 992px) {
            .qb-menu { display: none; }
            .qb-burger { display: inline-flex; }
            .qb-user span { display: none; }
            .qb-search.open input { width: 160px; }
        }

        .qb-drawer {
            position: fixed;
            top: 0; left: 0;
            width: 280px;
            height: 100vh;
            background: #fff;
            z-index: 1500;
            transform: translateX(-100%);
            transition: transform .25s;
            overflow-y: auto;
            box-shadow: 2px 0 16px rgba(0,0,0,0.1);
        }
        .qb-drawer.open { transform: translateX(0); }
        .qb-drawer-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1400;
            opacity: 0;
            visibility: hidden;
            transition: opacity .2s, visibility .2s;
        }
        .qb-drawer-overlay.open { opacity: 1; visibility: visible; }
        .qb-drawer-header {
            padding: 18px 20px;
            border-bottom: 1px solid var(--qb-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .qb-drawer-header .qb-logo { font-size: 20px; }
        .qb-drawer-close {
            border: none;
            background: transparent;
            font-size: 22px;
            cursor: pointer;
        }
        .qb-drawer ul {
            list-style: none;
            padding: 12px 0;
            margin: 0;
        }
        .qb-drawer ul li a {
            display: block;
            padding: 12px 20px;
            font-weight: 600;
            color: var(--qb-text);
            border-bottom: 1px solid var(--qb-border);
        }
        .qb-drawer ul li a:hover { background: #fef0f0; color: var(--qb-primary); }
        .qb-drawer ul li ul {
            background: #fafafa;
        }
        .qb-drawer ul li ul li a {
            padding-left: 36px;
            font-weight: 500;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div class="site-wrapper">

<header class="qb-header">
    <div class="qb-topbar">
        <i class="bi bi-truck"></i> Miễn phí vận chuyển cho đơn từ 500.000₫ &nbsp;|&nbsp; Hotline: 0123 456 789
    </div>
    <div class="qb-navbar">
        <a href="${pageContext.request.contextPath}/" class="qb-logo">
            <i class="bi bi-fire"></i>
            <div>
                QUÝ BỬU
                <small>ĐỒ COSPLAY &amp; ANIME</small>
            </div>
        </a>

        <button class="qb-burger" id="qbBurger" aria-label="Mở menu"><i class="bi bi-list"></i></button>

        <ul class="qb-menu" id="qbMenu">
            <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
            <li class="qb-dropdown">
                <a href="#" class="qb-dropdown-toggle">Danh Mục <i class="bi bi-chevron-down"></i></a>
                <ul class="qb-dropdown-menu">
                    <c:choose>
                        <c:when test="${not empty listDanhMuc}">
                            <c:forEach var="dm" items="${listDanhMuc}">
                                <li><a href="${pageContext.request.contextPath}/?category=${dm.id}">${dm.name}</a></li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <li><a href="#">Áo Thun Anime</a></li>
                            <li><a href="#">Áo Hoodie</a></li>
                            <li><a href="#">Cosplay &amp; Phụ Kiện</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </li>
            <li><a href="${pageContext.request.contextPath}/gio-hang">Giỏ Hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/lich-su-mua-hang">Lịch Sử Mua</a></li>
            <li><a href="#">Liên Hệ</a></li>
        </ul>

        <div class="qb-actions">
            <div class="qb-search" id="qbSearch">
                <i class="bi bi-search"></i>
                <input type="text" placeholder="Tìm sản phẩm...">
            </div>
            <button class="qb-icon-btn" id="qbSearchBtn" aria-label="Tìm kiếm"><i class="bi bi-search"></i></button>

            <c:choose>
                <c:when test="${not empty sessionScope.LOGIN_USER}">
                    <a href="${pageContext.request.contextPath}/lich-su-mua-hang" class="qb-user" title="Tài khoản">
                        <i class="bi bi-person-circle"></i>
                        <span>${sessionScope.LOGIN_USER.fullName}</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/login?action=logout" class="qb-user qb-user-logout" title="Đăng xuất">
                        <i class="bi bi-box-arrow-right"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="qb-user" title="Đăng nhập">
                        <i class="bi bi-person"></i>
                    </a>
                </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/gio-hang" class="qb-icon-btn" aria-label="Giỏ hàng">
                <i class="bi bi-bag"></i>
                <%
                    List<model.CartItem> cart = service.CartService.getCart(request.getSession());
                    int cartCount = cart.stream().mapToInt(model.CartItem::getQuantity).sum();
                    if (cartCount > 0) {
                %>
                        <span class="qb-badge"><%= cartCount %></span>
                <%  } %>
            </a>
        </div>
    </div>
</header>

<div class="qb-drawer-overlay" id="qbDrawerOverlay"></div>
<aside class="qb-drawer" id="qbDrawer">
    <div class="qb-drawer-header">
        <a href="${pageContext.request.contextPath}/" class="qb-logo">
            <i class="bi bi-fire"></i>
            <div>QUÝ BỬU</div>
        </a>
        <button class="qb-drawer-close" id="qbDrawerClose" aria-label="Đóng"><i class="bi bi-x-lg"></i></button>
    </div>
    <ul>
        <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
        <li>
            <a href="#">Danh Mục</a>
            <ul>
                <c:choose>
                    <c:when test="${not empty listDanhMuc}">
                        <c:forEach var="dm" items="${listDanhMuc}">
                            <li><a href="${pageContext.request.contextPath}/?category=${dm.id}">${dm.name}</a></li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <li><a href="#">Áo Thun Anime</a></li>
                        <li><a href="#">Áo Hoodie</a></li>
                        <li><a href="#">Cosplay &amp; Phụ Kiện</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </li>
        <li><a href="${pageContext.request.contextPath}/gio-hang">Giỏ Hàng</a></li>
        <li><a href="${pageContext.request.contextPath}/lich-su-mua-hang">Lịch Sử Mua</a></li>
        <li><a href="#">Liên Hệ</a></li>
        <c:choose>
            <c:when test="${not empty sessionScope.LOGIN_USER}">
                <li><a href="${pageContext.request.contextPath}/login?action=logout" style="color: var(--qb-primary);">Đăng Xuất</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/login">Đăng Nhập</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</aside>

<script>
(function() {
    var burger = document.getElementById('qbBurger');
    var drawer = document.getElementById('qbDrawer');
    var overlay = document.getElementById('qbDrawerOverlay');
    var closeBtn = document.getElementById('qbDrawerClose');
    function openDrawer() { drawer.classList.add('open'); overlay.classList.add('open'); }
    function closeDrawer() { drawer.classList.remove('open'); overlay.classList.remove('open'); }
    if (burger) burger.addEventListener('click', openDrawer);
    if (closeBtn) closeBtn.addEventListener('click', closeDrawer);
    if (overlay) overlay.addEventListener('click', closeDrawer);

    var searchBtn = document.getElementById('qbSearchBtn');
    var searchBox = document.getElementById('qbSearch');
    if (searchBtn && searchBox) {
        searchBtn.addEventListener('click', function() {
            searchBox.classList.toggle('open');
            if (searchBox.classList.contains('open')) {
                var inp = searchBox.querySelector('input');
                if (inp) inp.focus();
            }
        });
    }
})();
</script>