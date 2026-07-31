# Database Schema — QL_QUYBUU

## Files

| File | Mô tả |
|------|--------|
| `../docs/QL_QUYBUU.sql` | Script SQL Server đầy đủ (CREATE TABLE + INSERT seed data + INDEX) |
| `../docs/ER_DIAGRAM.md` | Sơ đồ ER dạng Markdown + giải thích quan hệ |

## Tổng quan

10 bảng chính, chuẩn hoá 3NF, đầy đủ FK + CHECK + UNIQUE constraints.

### Danh sách bảng

| # | Bảng | Mục đích |
|---|------|---------|
| 1 | `users` | Người dùng (ADMIN / STAFF / CUSTOMER) |
| 2 | `danh_muc` | Danh mục sản phẩm |
| 3 | `mau_sac` | Màu sắc |
| 4 | `kich_thuoc` | Kích thước (S, M, L, XL...) |
| 5 | `san_pham` | Sản phẩm cha (thông tin chung) |
| 6 | `san_pham_chi_tiet` | Biến thể SKU (kết hợp product + color + size) |
| 7 | `carts` | Header giỏ hàng (1 cart / user) |
| 8 | `cart_items` | Sản phẩm trong giỏ (snapshot) |
| 9 | `hoa_don` | Đơn hàng |
| 10 | `hoa_don_chi_tiet` | Sản phẩm trong đơn (snapshot) |

## Cách chạy

```sql
-- Mở SQL Server Management Studio (SSMS) hoặc Azure Data Studio
-- Mở file QL_QUYBUU.sql → Execute (F5)
-- DB "QL_QUYBUU" sẽ được tạo với 10 bảng + seed data mẫu
```

## Tài khoản mặc định (seed data)

| Email | Mật khẩu | Role |
|-------|----------|------|
| `admin@gmail.com` | `admin` | ADMIN |
| `truonglhtp01035@gmail.com` | `123654` | ADMIN |
| `nhanvien@quybuu.com` | `123123` | STAFF |
| `cuonglvtp01147@gmail.com` | `123890` | CUSTOMER |
| `khangnsmtp00908@gmail.com` | `123789` | CUSTOMER |

## Pattern thiết kế đáng chú ý

### 1. Product Variant (EAV-lite)
- `san_pham` chứa thông tin chung (tên, mô tả, base_price).
- `san_pham_chi_tiet` chứa thông tin riêng của từng SKU (giá riêng, tồn kho riêng).
- Cho phép 1 sản phẩm có nhiều màu × size với giá/tồn kho khác nhau.

### 2. Snapshot fields
- `cart_items.product_name`, `price` — không thay đổi nếu sản phẩm gốc đổi.
- `hoa_don_chi_tiet` lưu `product_name`, `color_name`, `size_name`, `price_at_purchase` — bảo toàn lịch sử đơn hàng.

### 3. Soft delete bằng `status`
- Bảng nào cũng có cột `status` (ACTIVE / INACTIVE hoặc ACTIVE / LOCKED).
- Không dùng DELETE thật — chỉ đổi status → dễ khôi phục, audit.

### 4. CHECK constraints
- Mọi cột enum (`role`, `status`, `payment_method`, `order_status`) đều có CHECK ở mức DB.
- Giảm bug ở tầng Java vì DB tự validate.

### 5. Cascade rule đúng chỗ
- `carts → cart_items` ON DELETE CASCADE (xoá user → xoá cart).
- `san_pham → cart_items` ON DELETE CASCADE (xoá SP → xoá khỏi giỏ).
- `users → hoa_don` KHÔNG cascade (giữ lịch sử đơn hàng dù user bị xoá).