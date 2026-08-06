<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .qb-footer {
        background: var(--qb-surface);
        color: var(--qb-text);
        padding: 64px 0 0;
        margin-top: 60px;
        font-size: 14px;
        line-height: 1.6;
        border-top: 1px solid var(--qb-border);
        transition: background .3s, color .3s, border-color .3s;
    }
    .qb-footer .qb-container {
        max-width: 1280px;
        margin: 0 auto;
        padding: 0 24px;
    }
    .qb-footer-grid {
        display: grid;
        grid-template-columns: 1.4fr 1fr 1fr 1fr;
        gap: 48px;
        padding-bottom: 48px;
        border-bottom: 1px solid var(--qb-border);
    }
    .qb-footer h5 {
        color: var(--qb-text);
        font-size: 15px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        margin: 0 0 20px;
        position: relative;
        padding-bottom: 12px;
    }
    .qb-footer h5::after {
        content: '';
        position: absolute;
        bottom: 0; left: 0;
        width: 32px; height: 3px;
        background: linear-gradient(90deg, var(--qb-primary) 0%, #ff8a8a 100%);
        border-radius: 2px;
    }
    .qb-footer-brand p { margin: 0 0 16px; color: var(--qb-muted); }
    .qb-footer-brand .qb-logo-foot {
        font-size: 26px;
        font-weight: 800;
        color: var(--qb-primary);
        letter-spacing: 1px;
        margin-bottom: 16px;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        transition: color .3s;
    }
    .qb-footer-brand .qb-logo-foot i { font-size: 28px; }
    .qb-footer-brand small {
        display: block;
        color: var(--qb-muted);
        font-size: 11px;
        letter-spacing: 2px;
        margin-top: 4px;
        transition: color .3s;
    }
    .qb-footer ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .qb-footer ul li { margin-bottom: 12px; }
    .qb-footer ul li a {
        color: var(--qb-muted);
        transition: all .2s;
        display: inline-block;
    }
    .qb-footer ul li a:hover {
        color: var(--qb-primary);
        padding-left: 6px;
    }
    .qb-footer ul li i { color: var(--qb-primary); margin-right: 10px; width: 16px; }
    .qb-footer-contact p { margin: 0 0 12px; color: var(--qb-muted); display: flex; align-items: flex-start; gap: 10px; }
    .qb-footer-contact p i { color: var(--qb-primary); margin-right: 0; width: auto; flex-shrink: 0; margin-top: 2px; }
    .qb-footer-contact p a { color: var(--qb-muted); transition: color .2s; }
    .qb-footer-contact p a:hover { color: var(--qb-primary); }

    .qb-social {
        display: flex;
        gap: 12px;
        margin-top: 20px;
    }
    .qb-social a {
        width: 48px;
        height: 48px;
        border-radius: 14px;
        background: var(--qb-bg);
        color: var(--qb-text);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        transition: all .3s cubic-bezier(0.16, 1, 0.3, 1);
        border: 1px solid var(--qb-border);
    }
    .qb-social a:hover {
        background: var(--qb-primary);
        color: #fff;
        border-color: var(--qb-primary);
        transform: translateY(-4px);
        box-shadow: 0 8px 20px rgba(214,40,40,0.3);
    }
    .qb-social a.bi-facebook:hover { background: #1877f2; border-color: #1877f2; }
    .qb-social a.bi-instagram:hover { background: linear-gradient(45deg, #f09433 0%, #e6683c 25%, #dc2743 50%, #cc2366 75%, #bc1888 100%); border-color: #e1306c; }
    .qb-social a.bi-tiktok:hover { background: #000; border-color: #000; }
    .qb-social a.bi-youtube:hover { background: #ff0000; border-color: #ff0000; }

    .qb-footer-bottom {
        padding: 24px 0;
        text-align: center;
        color: var(--qb-muted);
        font-size: 13px;
    }
    .qb-footer-bottom strong { color: var(--qb-primary); }

    @media (max-width: 992px) {
        .qb-footer-grid {
            grid-template-columns: repeat(2, 1fr);
            gap: 32px;
        }
    }
    @media (max-width: 768px) {
        .qb-footer-grid {
            grid-template-columns: 1fr 1fr;
            gap: 28px;
        }
    }
    @media (max-width: 480px) {
        .qb-footer-grid { grid-template-columns: 1fr; }
        .qb-social { gap: 10px; }
        .qb-social a { width: 44px; height: 44px; font-size: 18px; }
    }

    /* Back-to-top */
    .qb-back-top {
        position: fixed;
        right: 24px; bottom: 24px;
        width: 48px;
        height: 48px;
        border-radius: 14px;
        background: var(--qb-primary);
        color: #fff;
        border: none;
        display: none;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        cursor: pointer;
        box-shadow: 0 6px 20px rgba(214,40,40,0.4);
        z-index: 900;
        transition: all .3s cubic-bezier(0.16, 1, 0.3, 1);
    }
    .qb-back-top.show { display: inline-flex; }
    .qb-back-top:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 28px rgba(214,40,40,0.5);
        background: var(--qb-primary-dark);
    }

    /* Social fixed (left bottom) */
    .qb-social-fixed {
        position: fixed;
        left: 20px;
        bottom: 100px;
        display: flex;
        flex-direction: column;
        gap: 10px;
        z-index: 800;
    }
    .qb-social-fixed a {
        width: 48px;
        height: 48px;
        border-radius: 14px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: var(--qb-surface);
        color: #fff;
        font-size: 20px;
        box-shadow: 0 4px 16px var(--qb-shadow-lg);
        transition: all .3s cubic-bezier(0.16, 1, 0.3, 1);
        border: 1px solid var(--qb-border);
    }
    .qb-social-fixed a:hover {
        transform: translateX(4px) scale(1.05);
    }
    .qb-social-fixed .qb-phone { background: var(--qb-primary); border-color: var(--qb-primary); }
    .qb-social-fixed .qb-zalo  { background: #0068ff; border-color: #0068ff; }
    .qb-social-fixed .qb-mess  { background: #0084ff; border-color: #0084ff; }
    .qb-social-fixed .qb-yt    { background: #ff0000; border-color: #ff0000; }

    @media (max-width: 576px) {
        .qb-social-fixed {
            left: 12px;
            bottom: 80px;
        }
        .qb-social-fixed a {
            width: 44px;
            height: 44px;
            font-size: 18px;
        }
        .qb-back-top { right: 16px; bottom: 16px; }
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
                <p>Chuyên đồ Cosplay &amp; Anime chính hãng: Áo thun Anime, Áo Hoodie, Bộ Cosplay. Hàng chất lượng, giao hàng toàn quốc.</p>
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
                <p><i class="bi bi-geo-alt-fill"></i> TP. Hồ Chí Minh, Việt Nam</p>
                <p><i class="bi bi-telephone-fill"></i> Hotline: <a href="tel:0123456789">0123 456 789</a></p>
                <p><i class="bi bi-envelope-fill"></i> <a href="mailto:cskh@quybuu.vn">cskh@quybuu.vn</a></p>
                <p><i class="bi bi-clock-fill"></i> 9:00 - 21:00 (T2 - CN)</p>
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
        <strong style="font-size:14px;font-weight:800;">Z</strong>
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
        if (window.scrollY > 400) btn.classList.add('show');
        else btn.classList.remove('show');
    });
    btn.addEventListener('click', function() {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
})();
</script>

</body>
</html>
