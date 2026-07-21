<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"/>
<main class="mainContent-theme ">
<section class="section_product_top section container pd-top-30" id="section_product_new">
<div class=" card border-0 ">
<div id="owl-collection" class="d-flex-owl slick-callback" data-slides-md="5" data-slides-tablet="3" data-slides-xs="2" data-slides-md-scroll="2" data-slides-tablet-scroll="2" data-slides-xs-scroll="2" data-dots="false" data-autoplay="false" data-infinite="true" data-custom-arrows="true">
<c:forEach var="sp" items="${listNewProducts}">
<div class="d-flex-column"><div class="product-block item">
	<div class="product-img  has-hover"> 
		<a href="${pageContext.request.contextPath}/chi-tiet?id=${sp.id}" title="${sp.name}" class="image-resize ">
			<img class="lazyload dt-width-100 img-first" loading="lazy" width="260" height="260" src="${pageContext.request.contextPath}/${sp.image}" alt="${sp.name}">			
        </a>
		<div class="product-icon-action">
			<div class="add-to-cart"> 
				<a href="${pageContext.request.contextPath}/add-to-cart?id=${sp.id}" class="inline-block icon-addcart margin_right_10 box-shadow"> 
					<img width="20" height="20" src="${pageContext.request.contextPath}/images/tai_xuong_57e10f8e836049c2a2f1ef0d6f469ff4.png" alt="Thêm">
				</a>
			</div>
		</div>
	</div>
	<div class="product-detail">
		<h3 class="pro-name"><a href="${pageContext.request.contextPath}/chi-tiet?id=${sp.id}" title="${sp.name}">${sp.name}</a></h3>
		<div class="box-pro-prices">
			<p class="pro-price highlight">
				<span>${sp.basePrice} ₫</span>
			</p>
		</div>
	</div>
</div></div>
</c:forEach>
</div></div></section></main>
<jsp:include page="footer.jsp"/>
