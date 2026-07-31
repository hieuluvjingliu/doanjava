<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<jsp:include page="header.jsp"/>

<%
    List<?> rawList = (List<?>) request.getAttribute("listNewProducts");
    if (rawList == null) rawList = new ArrayList<>();
    int total = rawList.size();
    int chunkSize = 4;
    int totalSlides = (total == 0) ? 0 : (int) Math.ceil((double) total / chunkSize);
    request.setAttribute("_total", total);
    request.setAttribute("_totalSlides", totalSlides);
    request.setAttribute("_chunkSize", chunkSize);
%>

<style>
    .qb-section {
        padding: 40px 0;
        background: #fafafa;
    }
    .qb-section-title {
        text-align: center;
        margin-bottom: 28px;
        font-size: 26px;
        font-weight: 800;
        color: var(--qb-text, #222);
        letter-spacing: 1px;
        position: relative;
        padding-bottom: 12px;
    }
    .qb-section-title::after {
        content: '';
        position: absolute;
        bottom: 0; left: 50%;
        transform: translateX(-50%);
        width: 60px; height: 3px;
        background: var(--qb-primary, #d62828);
        border-radius: 2px;
    }
    .qb-section-title small {
        display: block;
        font-size: 13px;
        font-weight: 500;
        color: var(--qb-muted, #666);
        letter-spacing: 2px;
        margin-top: 4px;
    }

    .qb-product-card {
        background: #fff;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        transition: transform .2s, box-shadow .2s;
        height: 100%;
        display: flex;
        flex-direction: column;
    }
    .qb-product-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(0,0,0,0.12);
    }
    .qb-product-img {
        position: relative;
        width: 100%;
        aspect-ratio: 1 / 1;
        overflow: hidden;
        background: #f5f5f5;
    }
    .qb-product-img img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform .35s;
    }
    .qb-product-card:hover .qb-product-img img { transform: scale(1.06); }
    .qb-product-add-cart {
        position: absolute;
        right: 10px; bottom: 10px;
        width: 38px; height: 38px;
        border-radius: 50%;
        background: var(--qb-primary, #d62828);
        color: #fff;
        border: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        opacity: 0;
        transform: translateY(8px);
        transition: opacity .2s, transform .2s, background .15s;
        cursor: pointer;
    }
    .qb-product-card:hover .qb-product-add-cart {
        opacity: 1;
        transform: translateY(0);
    }
    .qb-product-add-cart:hover { background: var(--qb-primary-dark, #b71c1c); }
    .qb-product-body {
        padding: 14px 14px 16px;
        flex: 1;
        display: flex;
        flex-direction: column;
    }
    .qb-product-name {
        font-size: 14px;
        font-weight: 600;
        margin: 0 0 8px;
        line-height: 1.4;
        color: var(--qb-text, #222);
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        min-height: 2.8em;
    }
    .qb-product-name a { color: inherit; transition: color .15s; }
    .qb-product-name a:hover { color: var(--qb-primary, #d62828); }
    .qb-product-price {
        margin: 0;
        font-size: 16px;
        font-weight: 700;
        color: var(--qb-primary, #d62828);
        margin-top: auto;
    }

    .qb-carousel-controls {
        display: flex;
        gap: 8px;
        justify-content: center;
        margin-top: 24px;
    }
    .qb-carousel-btn {
        width: 40px; height: 40px;
        border-radius: 50%;
        background: #fff;
        border: 1px solid #ddd;
        color: var(--qb-text, #222);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        cursor: pointer;
        transition: background .15s, color .15s, border-color .15s;
    }
    .qb-carousel-btn:hover {
        background: var(--qb-primary, #d62828);
        color: #fff;
        border-color: var(--qb-primary, #d62828);
    }

    .qb-empty {
        text-align: center;
        padding: 60px 0;
        color: var(--qb-muted, #666);
    }
    .qb-empty .bi {
        font-size: 48px;
        margin-bottom: 12px;
        opacity: 0.4;
    }
    .qb-btn-secondary {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        background: #fff;
        color: var(--qb-text, #222);
        border: 1px solid #ddd;
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
        text-decoration: none;
        transition: background .15s, color .15s, border-color .15s;
    }
    .qb-btn-secondary:hover {
        background: var(--qb-primary, #d62828);
        color: #fff;
        border-color: var(--qb-primary, #d62828);
    }
</style>

<main>
    <section class="qb-section" id="section_product_new">
        <div class="container">
            <h2 class="qb-section-title">
                ${pageTitle}
                <small>${pageSubtitle}</small>
            </h2>

            <c:if test="${not empty activeCategoryId or not empty keyword}">
                <div style="text-align: center; margin-bottom: 12px;">
                    <a href="${ctx}/trang-chu" class="qb-btn-secondary">
                        <i class="bi bi-arrow-left"></i> Xem tất cả sản phẩm
                    </a>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${_total == 0}">
                    <div class="qb-empty">
                        <i class="bi bi-box-seam"></i>
                        <p>Chưa có sản phẩm nào.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div id="qbCarousel" class="carousel slide" data-bs-ride="false">
                        <div class="carousel-inner">
                            <c:forEach var="slideIdx" begin="0" end="${_totalSlides - 1}">
                                <div class="carousel-item ${slideIdx == 0 ? 'active' : ''}">
                                    <div class="row g-3">
                                        <c:set var="_start" value="${slideIdx * _chunkSize}"/>
                                        <c:set var="_end" value="${_start + _chunkSize - 1}"/>
                                        <c:forEach var="sp" items="${listNewProducts}" varStatus="status">
                                            <c:if test="${status.index >= _start && status.index <= _end && status.index < _total}">
                                                <div class="col-6 col-md-4 col-lg-3">
                                                    <div class="qb-product-card">
                                                        <div class="qb-product-img">
                                                            <a href="${ctx}/chi-tiet?id=${sp.id}" title="${sp.name}">
                                                                <img src="<my:safeImage value='${sp.image}' width='400' height='400'/>" alt="${sp.name}" loading="lazy">
                                                            </a>
                                                            <form action="${ctx}/gio-hang" method="post" style="margin:0;">
                                                                <input type="hidden" name="action" value="add">
                                                                <input type="hidden" name="productId" value="${sp.id}">
                                                                <input type="hidden" name="productName" value="${sp.name}">
                                                                <input type="hidden" name="productImage" value="<my:safeImage value='${sp.image}' width='400' height='400'/>">
                                                                <input type="hidden" name="price" value="${sp.basePrice}">
                                                                <input type="hidden" name="quantity" value="1">
                                                                <button type="submit" class="qb-product-add-cart" title="Thêm vào giỏ hàng" aria-label="Thêm vào giỏ hàng">
                                                                    <i class="bi bi-bag-plus"></i>
                                                                </button>
                                                            </form>
                                                        </div>
                                                        <div class="qb-product-body">
                                                            <h3 class="qb-product-name">
                                                                <a href="${ctx}/chi-tiet?id=${sp.id}" title="${sp.name}">${sp.name}</a>
                                                            </h3>
                                                            <p class="qb-product-price">${sp.basePrice} ₫</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <c:if test="${_totalSlides > 1}">
                            <div class="qb-carousel-controls">
                                <button class="qb-carousel-btn" type="button" data-bs-target="#qbCarousel" data-bs-slide="prev" aria-label="Slide trước">
                                    <i class="bi bi-chevron-left"></i>
                                </button>
                                <button class="qb-carousel-btn" type="button" data-bs-target="#qbCarousel" data-bs-slide="next" aria-label="Slide sau">
                                    <i class="bi bi-chevron-right"></i>
                                </button>
                            </div>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp"/>