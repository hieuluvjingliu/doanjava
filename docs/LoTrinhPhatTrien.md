# Lộ Trình Phát Triển Dự Án: Website Bán Quần Áo Quý Bửu

Dựa trên cấu trúc Database đã chốt và yêu cầu thực tế của một quy trình làm Web bằng Java (Servlet/JSP), dưới đây là lộ trình phát triển chi tiết từng bước (Step-by-Step). 

Việc chia nhỏ lộ trình này giúp team dễ dàng phân công công việc và không bị ngợp khi đối mặt với lượng code lớn.

---

## Giai Đoạn 1: Chuẩn bị Nền Tảng (Đã hoàn thành 80%)
**Mục tiêu:** Đảm bảo môi trường làm việc thông suốt từ Database lên Java.
- `[x]` Thiết kế và chạy script chốt Database `QL_QUYBUU.sql`.
- `[x]` Cấu hình chuỗi kết nối Database `ConnectDB.java`.
- `[x]` Thêm thư viện JDBC (SQL Server Driver) vào thư mục `WEB-INF/lib` (hoặc cấu hình pom.xml nếu dùng Maven).
- `[x]` Tạo cấu trúc các package: `controller`, `dao`, `model`, `utils`.

---

## Giai Đoạn 2: Xây Dựng Core (Model & DAO Cơ bản)
**Mục tiêu:** Ánh xạ các bảng trong DB thành Code Java và viết các hàm tương tác dữ liệu (Thêm/Sửa/Xóa).
*Gợi ý phân công: Mỗi thành viên nhận 1-2 bảng để viết.*
- `[x]` Model & DAO cho bảng **Danh mục** (`DanhMuc`, `DanhMucDAO`).
- `[x]` Model & DAO cho thuộc tính: **Màu sắc** và **Kích thước**.
- `[x]` Model & DAO cho **Người dùng** (`UserDAO` - Chú ý phần kiểm tra đăng nhập).
- `[x]` Model & DAO cho **Sản phẩm** (`SanPhamDAO` và `SanPhamChiTietDAO`).

---

## Giai Đoạn 3: Khu Vực Quản Trị (Admin Panel)
**Mục tiêu:** Xây dựng giao diện và luồng xử lý (Servlet) cho Admin quản lý cửa hàng (Thêm hàng, sửa giá, khóa tài khoản...).
- `[ ]` **Trang Quản lý Danh mục:** `DanhMucServlet` (Hiển thị list, Form thêm/sửa, Xóa).
- `[ ]` **Trang Quản lý Thuộc tính:** Cấu hình Màu sắc, Size.
- `[ ]` **Trang Quản lý Sản phẩm:** Giao diện thêm áo mới, tải ảnh lên, định giá cho từng Size/Màu.
- `[ ]` **Trang Quản lý Nhân viên/Khách hàng:** Liệt kê danh sách users, cấp quyền.
- `[ ]` (*Quan trọng*) **Bộ lọc bảo mật (Filter):** Chặn không cho user thường truy cập vào các link Admin.

---

## Giai Đoạn 4: Giao Diện Người Dùng (Public Frontend)
**Mục tiêu:** Xây dựng mặt tiền (Storefront) cho khách hàng xem và mua sắm.
- `[ ]` **Trang Chủ (`TrangChuServlet`):** Hiển thị các sản phẩm mới nhất, danh mục áo, banner Anime/Manga.
- `[ ]` **Trang Chi Tiết Sản Phẩm:** Khách bấm vào áo -> Hiện thông tin chi tiết, cho phép chọn Size, Màu.
- `[ ]` **Chức năng Đăng Nhập / Đăng Ký:** `LoginServlet`, lưu thông tin người dùng vào Session.
- `[ ]` **Trang Danh mục sản phẩm (Lọc):** Khách có thể tìm kiếm áo theo tên hoặc bấm vào danh mục "Áo Hoodie", "Áo thun"...

---

## Giai Đoạn 5: Giỏ Hàng & Thanh Toán (Tính năng lõi)
**Mục tiêu:** Xử lý luồng khách mua hàng trực tuyến.
- `[ ]` **Chức năng Giỏ hàng (`GioHangServlet`):**
  - Thêm sản phẩm (cùng size/màu) vào giỏ.
  - Tăng/giảm số lượng trong giỏ.
  - Xóa khỏi giỏ hàng.
- `[ ]` **Trang Thanh toán (Checkout):** 
  - Điền thông tin giao hàng (Lấy mặc định từ Session User nếu có).
  - Chọn phương thức thanh toán (COD hoặc Chuyển khoản).
  - Xử lý lưu đơn hàng xuống bảng `hoa_don` và `hoa_don_chi_tiet`.
  - (*Logic khó:*) Trừ số lượng tồn kho trong bảng `san_pham_chi_tiet`.

---

## Giai Đoạn 6: Xử Lý Đơn Hàng & Hoàn Thiện
**Mục tiêu:** Admin quản lý các đơn khách đã đặt và chốt dự án.
- `[ ]` **Quản lý Đơn Hàng (Admin):** Xem đơn mới đặt, đổi trạng thái đơn (Pending -> Confirmed -> Shipping).
- `[ ]` **Lịch sử mua hàng (Customer):** Khách hàng xem lại các đơn mình đã đặt.
- `[ ]` Thống kê doanh thu cơ bản (Tùy chọn nếu còn thời gian).
- `[ ]` Kiểm thử toàn bộ hệ thống (Fix bug, chuẩn hóa UI/UX).
