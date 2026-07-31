<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .qb-footer {
        background: #1a1a1a;
        color: #ddd;
        padding: 56px 0 0;
        margin-top: 60px;
        font-size: 14px;
        line-height: 1.6;
    }
    .qb-footer .qb-container {
        max-width: 1280px;
        margin: 0 auto;
        padding: 0 24px;
    }
    .qb-footer-grid {
        display: grid;
        grid-template-columns: 1.4fr 1fr 1fr 1fr;
        gap: 40px;
        padding-bottom: 40px;
        border-bottom: 1px solid #333;
    }
    .qb-footer h5 {
        color: #fff;
        font-size: 15px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin: 0 0 16px;
        position: relative;
        padding-bottom: 10px;
    }
    .qb-footer h5::after {
        content: '';
        position: absolute;
        bottom: 0; left: 0;
        width: 28px; height: 2px;
        background: var(--qb-primary, #d62828);
    }
    .qb-footer-brand p { margin: 0 0 12px; color: #aaa; }
    .qb-footer-brand .qb-logo-foot {
        font-size: 24px;
        font-weight: 800;
        color: var(--qb-primary, #d62828);
        letter-spacing: 1px;
        margin-bottom: 12px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
    .qb-footer-brand .qb-logo-foot i { font-size: 26px; }
    .qb-footer-brand small {
        display: block;
        color: #888;
        font-size: 11px;
        letter-spacing: 2px;
        margin-top: 2px;
    }
    .qb-footer ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .qb-footer ul li { margin-bottom: 10px; }
    .qb-footer ul li a {
        color: #ccc;
        transition: color .15s, padding-left .15s;
    }
    .qb-footer ul li a:hover {
        color: var(--qb-primary, #d62828);
        padding-left: 4px;
    }
    .qb-footer ul li i { color: var(--qb-primary, #d62828); margin-right: 8px; }
    .qb-footer-contact p { margin: 0 0 10px; color: #ccc; }
    .qb-footer-contact p i { color: var(--qb-primary, #d62828); margin-right: 8px; width: 16px; }

    .qb-social {
        display: flex;
        gap: 10px;
        margin-top: 14px;
    }
    .qb-social a {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background: #333;
        color: #fff;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 16px;
        transition: background .15s, transform .15s;
    }
    .qb-social a:hover {
        background: var(--qb-primary, #d62828);
        transform: translateY(-2px);
    }

    .qb-footer-bottom {
        padding: 18px 0;
        text-align: center;
        color: #888;
        font-size: 13px;
    }
    .qb-footer-bottom strong { color: var(--qb-primary, #d62828); }

    @media (max-width: 768px) {
        .qb-footer-grid {
            grid-template-columns: 1fr 1fr;
            gap: 28px;
        }
    }
    @media (max-width: 480px) {
        .qb-footer-grid { grid-template-columns: 1fr; }
    }

    /* Back-to-top */
    .qb-back-top {
        position: fixed;
        right: 20px; bottom: 20px;
        width: 44px; height: 44px;
        border-radius: 50%;
        background: var(--qb-primary, #d62828);
        color: #fff;
        border: none;
        display: none;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        cursor: pointer;
        box-shadow: 0 4px 12px rgba(214, 40, 40, 0.4);
        z-index: 900;
        transition: transform .15s;
    }
    .qb-back-top.show { display: inline-flex; }
    .qb-back-top:hover { transform: translateY(-3px); }

    /* Social fixed (left bottom) */
    .qb-social-fixed {
        position: fixed;
        left: 16px; bottom: 80px;
        display: flex;
        flex-direction: column;
        gap: 8px;
        z-index: 800;
    }
    .qb-social-fixed a {
        width: 44px; height: 44px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: #fff;
        color: #fff;
        font-size: 18px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        transition: transform .15s;
    }
    .qb-social-fixed a:hover { transform: scale(1.08); }
    .qb-social-fixed .qb-phone { background: var(--qb-primary, #d62828); }
    .qb-social-fixed .qb-zalo  { background: #0068ff; }
    .qb-social-fixed .qb-mess  { background: #0084ff; }
    .qb-social-fixed .qb-yt    { background: #ff0000; }

    @media (max-width: 576px) {
        .qb-social-fixed { left: 10px; bottom: 70px; }
        .qb-social-fixed a { width: 40px; height: 40px; font-size: 16px; }
    }
</style>

<footer class="qb-footer">
    <div class="qb-container">
        <div class="qb-footer-grid">

            <div class="qb-footer-brand">
                <div class="qb-logo-foot">
                    <i class="bi bi-fire"></i>
                    <div>
                        QUÝ BỬU
                        <small>ĐỒ COSPLAY &amp; ANIME</small>
                    </div>
                </div>
                <p>Chuyên đồ Cosplay &amp; Anime chính hãng: Áo thun Anime, Áo Hoodie, Cosplay &amp; phụ kiện. Hàng chất lượng, giao hàng toàn quốc.</p>
                <div class="qb-social">
                    <a href="#" title="Facebook"><i class="bi bi-facebook"></i></a>
                    <a href="#" title="Instagram"><i class="bi bi-instagram"></i></a>
                    <a href="#" title="TikTok"><i class="bi bi-tiktok"></i></a>
                    <a href="#" title="YouTube"><i class="bi bi-youtube"></i></a>
                </div>
            </div>

            <div>
                <h5>Về Quý Bửu</h5>
                <ul>
                    <li><a href="#">Giới thiệu</a></li>
                    <li><a href="#">Liên hệ</a></li>
                    <li><a href="#">Tuyển dụng</a></li>
                    <li><a href="#">Tin tức</a></li>
                </ul>
            </div>

            <div>
                <h5>Hỗ Trợ Khách Hàng</h5>
                <ul>
                    <li><a href="#">Chính sách đổi trả</a></li>
                    <li><a href="#">Chính sách bảo hành</a></li>
                    <li><a href="#">Chính sách giao hàng</a></li>
                    <li><a href="#">Chính sách bảo mật</a></li>
                    <li><a href="#">Hướng dẫn mua hàng</a></li>
                    <li><a href="#">Câu hỏi thường gặp</a></li>
                </ul>
            </div>

            <div class="qb-footer-contact">
                <h5>Liên Hệ</h5>
                <p><i class="bi bi-geo-alt"></i> TP. Hồ Chí Minh, Việt Nam</p>
                <p><i class="bi bi-telephone"></i> Hotline: <a href="tel:0123456789">0123 456 789</a></p>
                <p><i class="bi bi-envelope"></i> <a href="mailto:cskh@quybuu.vn">cskh@quybuu.vn</a></p>
                <p><i class="bi bi-clock"></i> 9:00 - 21:00 (T2 - CN)</p>
            </div>

        </div>

        <div class="qb-footer-bottom">
            © 2026 <strong>QUÝ BỬU</strong>. Đã đăng ký bản quyền. Thiết kế bởi Quý Bửu Team.
        </div>
    </div>
</footer>

<div class="qb-social-fixed" aria-label="Liên hệ nhanh">
    <a href="tel:0123456789" class="qb-phone" title="Gọi điện"><i class="bi bi-telephone-fill"></i></a>
    <a href="https://zalo.me/0123456789" target="_blank" class="qb-zalo" title="Zalo">
        <strong style="font-size:13px;">Z</strong>
    </a>
    <a href="https://m.me/" target="_blank" class="qb-mess" title="Messenger"><i class="bi bi-messenger"></i></a>
</div>

<button class="qb-back-top" id="qbBackTop" aria-label="Lên đầu trang"><i class="bi bi-arrow-up"></i></button>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
(function() {
    var btn = document.getElementById('qbBackTop');
    if (!btn) return;
    window.addEventListener('scroll', function() {
        if (window.scrollY > 300) btn.classList.add('show');
        else btn.classList.remove('show');
    });
    btn.addEventListener('click', function() {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
})();
</script>

</body>
</html>
