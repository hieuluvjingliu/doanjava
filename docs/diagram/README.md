# Activity Diagrams — QUYBUU Store

Bộ diagram UML Activity cho **toàn bộ chức năng** của dự án `doanquanaoquybuu`, được vẽ bằng định dạng XML chuẩn của [drawio.com](https://www.drawio.com/).

## Cách sử dụng

1. Truy cập [https://www.drawio.com/](https://www.drawio.com/) (hoặc app desktop).
2. Mở file `.drawio` bất kỳ trong thư mục `diagram/`.
3. Hoặc kéo thả file vào giao diện để mở ngay.

## Danh sách diagram

### Khu vực khách hàng (`/`, `/trang-chu`, `/chi-tiet`)

| # | File | Mô tả |
|---|------|--------|
| 01 | `01_TrangChu_TimKiem.drawio` | Trang chủ: hiển thị sản phẩm, lọc theo danh mục, tìm kiếm theo từ khóa |
| 02 | `02_ChiTietSanPham.drawio` | Xem chi tiết một sản phẩm kèm danh sách biến thể (size, màu, tồn kho) |
| 03 | `03_DangKy.drawio` | Đăng ký tài khoản khách hàng với validation (email, SĐT, mật khẩu) |
| 04 | `04_DangNhap.drawio` | Đăng nhập và phân quyền theo role (ADMIN/STAFF/CUSTOMER) |
| 05 | `05_DangXuat.drawio` | Đăng xuất: hủy session |

### Giỏ hàng & đơn hàng

| # | File | Mô tả |
|---|------|--------|
| 06 | `06_GioHang_Them.drawio` | Thêm sản phẩm vào giỏ (cộng dồn quantity nếu trùng variant) |
| 07 | `07_GioHang_Update_Remove_Clear.drawio` | Cập nhật / xóa một / xóa toàn bộ giỏ hàng |
| 08 | `08_MergeCart_OnLogin.drawio` | Hợp nhất giỏ session với gi� DB khi đăng nhập |
| 09 | `09_ThanhToan_Checkout.drawio` | Thanh toán / đặt hàng với transaction SQL Server |
| 10 | `10_LichSuMuaHang.drawio` | Xem lịch sử mua hàng của khách |

### Khu vực quản trị (`/admin/*`)

| # | File | Mô tả |
|---|------|--------|
| 11 | `11_AdminFilter_PhanQuyen.drawio` | AdminFilter — bảo vệ khu vực admin (chặn STAFF một số quyền) |
| 12 | `12_Dashboard_Admin.drawio` | Dashboard thống kê tổng quan |
| 13 | `13_QuanLyDonHang_Admin.drawio` | Danh sách đơn hàng (phân trang) + chi tiết + cập nhật trạng thái |
| 14 | `14_QuanLySanPham_Admin.drawio` | CRUD sản ph�m + badge tồn kho |
| 15 | `15_QuanLyBienThe_Admin.drawio` | CRUD biến thể (size, màu, SKU, giá riêng, tồn kho) |
| 16 | `16_QuanLyDanhMuc_Admin.drawio` | CRUD danh mục sản ph�m |
| 17 | `17_QuanLyKichThuoc_MauSac_Admin.drawio` | CRUD kích thước / màu sắc |
| 18 | `18_QuanLyNguoiDung_Admin.drawio` | CRUD người dùng + chặn tự giáng quyền |

### Chung

| # | File | Mô tả |
|---|------|--------|
| 19 | `19_GlobalErrorHandler.drawio` | Bắt exception toàn cục → `/error.jsp` |
| 20 | `20_TongQuan_LuongNguoiDung.drawio` | Tổng quan luồng người dùng end-to-end |

## Chú thích màu sắc trong diagram

- **Xanh lá (`#CCFFCC`)** — Bước thành công / điều hướng về trang chính.
- **Vàng (`#FFFFCC`)** — Tầng Service / DAO (business logic).
- **Đỏ nhạt (`#FFCCCC`)** — Bước thất bại / redirect về trang lỗi.
- **Trắng** — Action / Servlet / Controller bình thường.
