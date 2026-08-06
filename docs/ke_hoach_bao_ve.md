# Kế hoạch Chuẩn bị Bảo vệ Đồ án - Nhóm 5 Người (Dự án QUYBUU Store)

Dưới đây là bản phân công và kế hoạch chuẩn bị bảo vệ đã được tinh chỉnh lại sát với thực tế nhóm của bạn: 2 bạn làm Admin, 2 bạn làm Client và bạn (Trưởng nhóm) gánh vác phần khung hệ thống, tích hợp và các tính năng cốt lõi còn lại.

---

## 1. Phân chia Vai trò & Trách nhiệm 

| Vai trò | Trách nhiệm chính (Khi code & Viết báo cáo) | Phần cần nắm vững để trả lời phản biện |
| :--- | :--- | :--- |
| **Thành viên 1 & 2: ** | - Tự chia nhau toàn bộ phần `/admin/*`.<br>- Quản lý Đơn hàng, Thống kê, Dashboard.<br>- CRUD Sản phẩm, Danh mục, Biến thể, Người dùng. | - Xử lý upload ảnh (Multipart).<br>- Phân trang danh sách (SQL `OFFSET FETCH`).<br>- Tính toán doanh thu, cập nhật trạng thái đơn hàng. |
| **Thành viên 3: Khách hàng (Auth & Cart)** | - Code chức năng: Đăng nhập, Đăng ký.<br>- Code chức năng: Thêm sản phẩm vào Giỏ hàng. | - Logic lưu Session (`LOGIN_USER`, `CART`).<br>- Validate dữ liệu đầu vào (Email, Password).<br>- Lưu giỏ hàng xuống CSDL khi user đăng nhập. |
| **Thành viên 4: Khách hàng (Hiển thị)** | - Code chức năng: Trang chủ, Hiển thị danh sách Sản phẩm theo Danh mục.<br>- Giao diện HTML/CSS/JSP phía Client. | - Cách lấy dữ liệu từ Servlet hiển thị lên JSP (dùng `<c:forEach>` của JSTL).<br>- Cắt HTML/CSS thành các file `header.jsp`, `footer.jsp`. |
| **Bạn (Trưởng nhóm): Core, Checkout, Security & QA** | - **Chức năng Client:** Tìm kiếm sản phẩm, Lịch sử mua hàng của khách.<br>- **Nghiệp vụ cốt lõi:** Thanh toán/Đặt hàng (Checkout logic).<br>- **Bảo mật (Security):** Viết `Filter` để chặn truy cập trái phép (VD: Khách chưa login không được vào Giỏ hàng, Khách thường không được vào link `/admin/*`).<br>- **Hệ thống:** Thiết kế Database (ERD), cấu trúc MVC, kết nối JDBC.<br>- **Quản lý:** Ghép code, Test lỗi, Viết báo cáo, Làm Slide. | - **Rất quan trọng:** Luồng Đặt hàng (Transaction: lưu Hóa đơn -> lưu Chi tiết -> Trừ tồn kho).<br>- Cơ chế hoạt động của `Filter` trong Servlet.<br>- Sơ đồ kiến trúc MVC, Sơ đồ CSDL (ERD).<br>- Xử lý luồng dữ liệu tổng quan, định hướng trả lời. |
---

## 2. Kế hoạch Chuẩn bị & Kịch bản Demo

### Giai đoạn 1: Chuẩn bị Báo cáo & Slide
- **Các thành viên:** Viết word mô tả chức năng của mình (có ảnh chụp màn hình).
- **Trưởng nhóm:** Gom các file word lại, làm chung 1 form. Viết phần Mở đầu, Kết luận, vẽ Sơ đồ luồng, ERD. Chuẩn bị Slide (tập trung vào Sơ đồ và Demo).

### Giai đoạn 2: Kịch bản Demo thực tế (Trơn tru theo luồng)
1. **(Bạn - Trưởng nhóm)**: Mở đầu, giới thiệu kiến trúc. Demo **Tìm kiếm** một sản phẩm và demo **Bảo mật chặn link** (gõ url `/admin` khi chưa login sẽ bị đẩy về trang đăng nhập).
2. **(Thành viên 4)**: Demo trang chủ, bấm vào danh mục để lọc sản phẩm, bấm vào xem chi tiết sản phẩm đó.
3. **(Thành viên 3)**: Demo việc bấm Thêm vào giỏ hàng. Đăng ký tài khoản mới -> Đăng nhập -> Thêm lại vào giỏ hàng.
4. **(Bạn - Trưởng nhóm)**: Demo vào giỏ hàng -> **Thanh toán**. Show thông báo đặt hàng thành công và xem Lịch sử đơn hàng.
5. **(Thành viên 1 & 2)**: Đăng nhập tài khoản Admin. Show Dashboard doanh thu. Vào Đơn hàng để **Duyệt đơn**. Vào Sản phẩm để show số lượng tồn kho đã giảm.

### Giai đoạn 3: Diễn tập (Mock Defense)
1. **Câu hỏi cho bạn:** "Luồng thanh toán em xử lý thế nào? Nếu đang lưu chi tiết mà lỗi thì sao?" -> *(Trả lời về Transaction/Rollback).* "Em dùng cơ chế nào để bảo vệ các trang của Admin?" -> *(Trả lời về Java Filter/Session).*
2. **Câu hỏi cho TV 1&2:** "Làm sao Admin biết đơn hàng nào mới đặt để duyệt? Có phân trang không?"
3. **Câu hỏi cho TV 3:** "Mật khẩu lưu trong DB có mã hóa không? Giỏ hàng dùng session thì tắt trình duyệt bị mất đúng không?"
4. **Câu hỏi cho TV 4:** "JSP giao tiếp với Servlet qua đâu? Request Dispatcher và Redirect khác nhau chỗ nào?"

---

## 3. Checklist Ngày Bảo Vệ (Dành riêng cho Trưởng nhóm)
- [ ] Giữ 1 bản **Source Code gốc chạy hoàn hảo** + 1 file **Backup Database (`.bak` hoặc `.sql`)** trong USB hoặc Google Drive.
- [ ] Chịu trách nhiệm bật máy chiếu, Start Tomcat, và test đường truyền.
- [ ] Mở sẵn Eclipse và SQL Server. Tắt hết các tab thừa, chỉ mở đúng `OrderService`, `AdminFilter.java`, `HoaDonDAO`.
- [ ] Khi hội đồng hỏi 1 thành viên bị bí, Trưởng nhóm xin phép trả lời đỡ để tránh mất điểm cả nhóm.
