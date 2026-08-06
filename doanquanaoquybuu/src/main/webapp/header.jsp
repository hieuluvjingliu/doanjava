<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="service.CartService" %>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Quý Bửu - Hòa vào thế giới Quý Bửu: Áo thun Anime, Áo Hoodie, Bộ Cosplay. Hàng chất lượng, giao hàng toàn quốc.">
    <meta name="keywords" content="cosplay, anime, áo thun anime, hoodie anime, áo khoác cosplay, bộ cosplay, quý bửu">
    <title>Quý Bửu - Hòa vào thế giới Quý Bửu</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --qb-primary: #d62828;
            --qb-primary-dark: #b71c1c;
            --qb-text: #222;
            --qb-muted: #666;
            --qb-bg: #f8f9fc;
            --qb-surface: #ffffff;
            --qb-border: #eee;
            --qb-header-h: 64px;
            --qb-accent: #6366f1;
            --qb-shadow: rgba(0,0,0,0.06);
            --qb-shadow-lg: rgba(0,0,0,0.1);
        }

        [data-theme="dark"] {
            --qb-primary: #ef4444;
            --qb-primary-dark: #dc2626;
            --qb-text: #f3f4f6;
            --qb-muted: #9ca3af;
            --qb-bg: #0f0f1a;
            --qb-surface: #1a1a2e;
            --qb-border: #2d2d4a;
            --qb-shadow: rgba(0,0,0,0.3);
            --qb-shadow-lg: rgba(0,0,0,0.4);
        }

        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            color: var(--qb-text);
            margin: 0;
            background: var(--qb-bg);
            transition: background .3s, color .3s;
        }
        a { text-decoration: none; color: inherit; }

        .qb-header {
            background: var(--qb-surface);
            border-bottom: 1px solid var(--qb-border);
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 12px var(--qb-shadow);
            transition: background .3s, box-shadow .3s, border-color .3s;
        }
        .qb-topbar {
            background: #111;
            color: #fff;
            font-size: 12px;
            padding: 6px 0;
            text-align: center;
            letter-spacing: 0.5px;
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
            transition: color .3s;
        }
        .qb-logo .bi-fire { font-size: 26px; }
        .qb-logo small {
            font-size: 10px;
            font-weight: 500;
            color: var(--qb-muted);
            letter-spacing: 2px;
            display: block;
            margin-top: -4px;
            transition: color .3s;
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
            transition: color .2s;
        }
        .qb-menu > li > a:hover { color: var(--qb-primary); }
        .qb-menu > li > a::after {
            content: '';
            position: absolute;
            left: 0; bottom: 0;
            width: 0; height: 2px;
            background: var(--qb-primary);
            transition: width .25s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .qb-menu > li > a:hover::after { width: 100%; }

        .qb-dropdown { position: relative; }
        .qb-dropdown-toggle .bi-chevron-down { font-size: 11px; margin-left: 4px; transition: transform .2s; }
        .qb-dropdown:hover .qb-dropdown-toggle .bi-chevron-down { transform: rotate(180deg); }
        .qb-dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            background: var(--qb-surface);
            min-width: 220px;
            border: 1px solid var(--qb-border);
            border-radius: 12px;
            box-shadow: 0 12px 40px var(--qb-shadow-lg);
            padding: 10px 0;
            list-style: none;
            margin: 8px 0 0;
            opacity: 0;
            visibility: hidden;
            transform: translateY(8px);
            transition: all .25s cubic-bezier(0.16, 1, 0.3, 1);
            z-index: 1100;
        }
        .qb-dropdown:hover .qb-dropdown-menu {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }
        .qb-dropdown-menu li a {
            display: block;
            padding: 10px 18px;
            color: var(--qb-text);
            font-size: 14px;
            transition: all .15s;
        }
        .qb-dropdown-menu li a:hover {
            background: rgba(214,40,40,0.08);
            color: var(--qb-primary);
            padding-left: 22px;
        }

        .qb-actions {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-left: auto;
        }

        /* Theme Toggle */
        .qb-theme-toggle {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            border: none;
            background: var(--qb-bg);
            color: var(--qb-text);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            position: relative;
            cursor: pointer;
            transition: all .25s cubic-bezier(0.16, 1, 0.3, 1);
            font-size: 18px;
        }
        .qb-theme-toggle:hover {
            background: var(--qb-primary);
            color: #fff;
            transform: rotate(15deg);
        }
        .qb-theme-toggle .bi-moon { display: none; }
        [data-theme="dark"] .qb-theme-toggle .bi-sun { display: none; }
        [data-theme="dark"] .qb-theme-toggle .bi-moon { display: inline; }

        .qb-icon-btn {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            border: none;
            background: var(--qb-bg);
            color: var(--qb-text);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            position: relative;
            cursor: pointer;
            transition: all .25s cubic-bezier(0.16, 1, 0.3, 1);
            font-size: 18px;
        }
        .qb-icon-btn:hover {
            background: var(--qb-primary);
            color: #fff;
            transform: translateY(-2px);
        }
        .qb-badge {
            position: absolute;
            top: 4px; right: 4px;
            min-width: 18px;
            height: 18px;
            padding: 0 5px;
            background: var(--qb-primary);
            color: #fff;
            border-radius: 9px;
            font-size: 10px;
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
            border-radius: 12px;
            transition: width .3s cubic-bezier(0.16, 1, 0.3, 1), padding .3s, border-color .3s, background .3s;
            outline: none;
            font-size: 14px;
            background: var(--qb-bg);
            color: var(--qb-text);
        }
        .qb-search.open input {
            width: 220px;
            padding: 10px 14px 10px 38px;
            border-color: var(--qb-border);
        }
        .qb-search .bi-search {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--qb-muted);
            pointer-events: none;
            transition: color .3s;
        }
        .qb-search input:focus { border-color: var(--qb-primary); }
        .qb-search input:focus + .bi-search,
        .qb-search.open .bi-search { color: var(--qb-primary); }

        .qb-user {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
            padding: 8px 14px;
            border-radius: 12px;
            border: none;
            background: var(--qb-bg);
            transition: all .2s;
        }
        .qb-user:hover {
            background: var(--qb-primary);
            color: #fff;
        }
        .qb-user-logout { color: var(--qb-primary); }
        .qb-user-logout:hover { color: #fff; }

        .qb-burger {
            display: none;
            background: transparent;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: var(--qb-text);
        }

        @media (max-width: 992px) {
            .qb-menu { display: none; }
            .qb-burger { display: inline-flex; }
            .qb-user span { display: none; }
            .qb-user { padding: 8px; }
            .qb-search.open input { width: 160px; }
        }

        /* Mobile Drawer */
        .qb-drawer {
            position: fixed;
            top: 0; left: 0;
            width: 300px;
            height: 100vh;
            background: var(--qb-surface);
            z-index: 1500;
            transform: translateX(-100%);
            transition: transform .3s cubic-bezier(0.16, 1, 0.3, 1);
            overflow-y: auto;
            box-shadow: 4px 0 24px var(--qb-shadow-lg);
        }
        .qb-drawer.open { transform: translateX(0); }
        .qb-drawer-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1400;
            opacity: 0;
            visibility: hidden;
            transition: opacity .3s, visibility .3s;
        }
        .qb-drawer-overlay.open { opacity: 1; visibility: visible; }
        .qb-drawer-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--qb-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--qb-surface);
        }
        .qb-drawer-header .qb-logo { font-size: 20px; }
        .qb-drawer-close {
            border: none;
            background: var(--qb-bg);
            width: 36px;
            height: 36px;
            border-radius: 10px;
            font-size: 18px;
            cursor: pointer;
            color: var(--qb-text);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all .2s;
        }
        .qb-drawer-close:hover {
            background: var(--qb-primary);
            color: #fff;
        }
        .qb-drawer ul {
            list-style: none;
            padding: 12px 0;
            margin: 0;
        }
        .qb-drawer ul li a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 24px;
            font-weight: 600;
            color: var(--qb-text);
            border-bottom: 1px solid var(--qb-border);
            transition: all .15s;
        }
        .qb-drawer ul li a:hover {
            background: rgba(214,40,40,0.06);
            color: var(--qb-primary);
            padding-left: 28px;
        }
        .qb-drawer ul li ul {
            background: var(--qb-bg);
        }
        .qb-drawer ul li ul li a {
            padding-left: 44px;
            font-weight: 500;
            font-size: 14px;
        }
        .qb-drawer ul li ul li a:hover { padding-left: 52px; }
    </style>
</head>
<body>
<div class="site-wrapper">

<header class="qb-header">
    <div class="qb-topbar">
        <i class="bi bi-lightning-charge-fill"></i> Miễn phí vận chuyển cho đơn từ 500.000₫ &nbsp;|&nbsp; Hotline: 0123 456 789
    </div>
    <div class="qb-navbar">
        <a href="${pageContext.request.contextPath}/trang-chu" class="qb-logo">
            <i class="bi bi-fire"></i>
            <div>
                QUÝ BỬU
                <small>HÒA VÀO THẾ GIỚI QUÝ BỬU</small>
            </div>
        </a>

        <button class="qb-burger" id="qbBurger" aria-label="Mở menu"><i class="bi bi-list"></i></button>

        <ul class="qb-menu" id="qbMenu">
            <li><a href="${pageContext.request.contextPath}/trang-chu">Trang Chủ</a></li>
            <li class="qb-dropdown">
                <a href="#" class="qb-dropdown-toggle">Danh Mục <i class="bi bi-chevron-down"></i></a>
                <ul class="qb-dropdown-menu">
                    <c:choose>
                        <c:when test="${not empty listDanhMuc}">
                            <c:forEach var="dm" items="${listDanhMuc}">
                                <li><a href="${pageContext.request.contextPath}/trang-chu?category=${dm.id}">${dm.name}</a></li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <li><a href="${pageContext.request.contextPath}/trang-chu">Tất cả sản phẩm</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </li>
            <li><a href="${pageContext.request.contextPath}/gio-hang">Giỏ Hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/lich-su-mua-hang">Lịch Sử Mua</a></li>
        </ul>

        <div class="qb-actions">
            <form action="${pageContext.request.contextPath}/trang-chu" method="get" class="qb-search" id="qbSearch">
                <i class="bi bi-search"></i>
                <input type="text" name="keyword" id="qbSearchInput" placeholder="Tìm sản phẩm..." value="${keyword}" autocomplete="off">
            </form>
            <button class="qb-icon-btn" id="qbSearchBtn" type="button" aria-label="Tìm kiếm"><i class="bi bi-search"></i></button>

            <!-- Dark Mode Toggle -->
            <button class="qb-theme-toggle" id="qbThemeToggle" type="button" aria-label="Chuyển chế độ sáng/tối">
                <i class="bi bi-sun"></i>
                <i class="bi bi-moon"></i>
            </button>

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
        <a href="${pageContext.request.contextPath}/trang-chu" class="qb-logo">
            <i class="bi bi-fire"></i>
            <div>QUÝ BỬU</div>
        </a>
        <button class="qb-drawer-close" id="qbDrawerClose" aria-label="Đóng"><i class="bi bi-x-lg"></i></button>
    </div>
    <ul>
        <li><a href="${pageContext.request.contextPath}/trang-chu"><i class="bi bi-house"></i> Trang Chủ</a></li>
        <li>
            <a href="#"><i class="bi bi-grid"></i> Danh Mục</a>
            <ul>
                <c:choose>
                    <c:when test="${not empty listDanhMuc}">
                        <c:forEach var="dm" items="${listDanhMuc}">
                            <li><a href="${pageContext.request.contextPath}/trang-chu?category=${dm.id}">${dm.name}</a></li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/trang-chu">Tất cả sản phẩm</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </li>
        <li><a href="${pageContext.request.contextPath}/gio-hang"><i class="bi bi-bag"></i> Giỏ Hàng</a></li>
        <li><a href="${pageContext.request.contextPath}/lich-su-mua-hang"><i class="bi bi-clock-history"></i> Lịch Sử Mua</a></li>
        <c:choose>
            <c:when test="${not empty sessionScope.LOGIN_USER}">
                <li><a href="${pageContext.request.contextPath}/login?action=logout" style="color: var(--qb-primary);"><i class="bi bi-box-arrow-right"></i> Đăng Xuất</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/login"><i class="bi bi-person"></i> Đăng Nhập</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</aside>

<script>
(function() {
    // Mobile Drawer
    var burger = document.getElementById('qbBurger');
    var drawer = document.getElementById('qbDrawer');
    var overlay = document.getElementById('qbDrawerOverlay');
    var closeBtn = document.getElementById('qbDrawerClose');
    function openDrawer() { drawer.classList.add('open'); overlay.classList.add('open'); document.body.style.overflow = 'hidden'; }
    function closeDrawer() { drawer.classList.remove('open'); overlay.classList.remove('open'); document.body.style.overflow = ''; }
    if (burger) burger.addEventListener('click', openDrawer);
    if (closeBtn) closeBtn.addEventListener('click', closeDrawer);
    if (overlay) overlay.addEventListener('click', closeDrawer);

    // Search Toggle
    var searchBtn = document.getElementById('qbSearchBtn');
    var searchBox = document.getElementById('qbSearch');
    var searchInput = document.getElementById('qbSearchInput');
    if (searchBtn && searchBox) {
        searchBtn.addEventListener('click', function() {
            if (searchInput && searchInput.value.trim().length > 0) {
                searchBox.submit();
                return;
            }
            searchBox.classList.toggle('open');
            if (searchBox.classList.contains('open') && searchInput) {
                searchInput.focus();
            }
        });
    }

    // Dark Mode Toggle
    var themeToggle = document.getElementById('qbThemeToggle');
    var html = document.documentElement;
    
    // Check saved theme or system preference
    var savedTheme = localStorage.getItem('qb-theme');
    if (savedTheme) {
        html.setAttribute('data-theme', savedTheme);
    } else if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
        html.setAttribute('data-theme', 'dark');
    }

    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            var currentTheme = html.getAttribute('data-theme');
            var newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            html.setAttribute('data-theme', newTheme);
            localStorage.setItem('qb-theme', newTheme);
        });
    }

    // Listen for system theme changes
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function(e) {
        if (!localStorage.getItem('qb-theme')) {
            html.setAttribute('data-theme', e.matches ? 'dark' : 'light');
        }
    });
})();
</script>
