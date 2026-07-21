<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<style>
    .cart-container { max-width: 800px; margin: 60px auto; padding: 40px; border-radius: 10px; background: #fff;}
    .cart-title { font-size: 28px; font-weight: bold; text-align: center; margin-bottom: 30px; letter-spacing: 1px;}
    .btn-checkout { background-color: #000; color: #fff; border: none; padding: 15px; font-size: 16px; font-weight: bold; border-radius: 5px; transition: 0.3s; display: block; text-align: center; text-decoration: none;}
    .btn-checkout:hover { background-color: #333; color: white;}
</style>

<div class="container">
    <div class="cart-container text-center">
        <h2 class="cart-title"><i class="fa-solid fa-cart-shopping"></i> GIỎ HÀNG CỦA BẠN</h2>
        
        <p class="text-success fw-bold">Tính năng giỏ hàng đang được nâng cấp!</p>
        <p class="mb-4">Hiện tại bạn đã thêm sản phẩm thành công vào phiên (Session).</p>
        
        <a href="trang-chu" class="btn btn-outline-dark me-2">TIẾP TỤC MUA SẮM</a>
        <a href="#" class="btn-checkout d-inline-block mt-3" style="width: auto; padding-left: 30px; padding-right: 30px;">TIẾN HÀNH THANH TOÁN (DEMO)</a>
    </div>
</div>

<jsp:include page="footer.jsp" />
