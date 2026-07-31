# Sơ đồ ER — Cơ sở dữ liệu QL_QUYBUU

> Database: `QL_QUYBUU` (SQL Server 2019+) — Mã hoá UTF-8 với `NVARCHAR` hỗ trợ tiếng Việt.

## Sơ đồ quan hệ tổng quan

```
                ┌─────────────────────┐
                │      USERS          │
                │ (Khách / Admin)     │
                └──────────┬──────────┘
                           │ 1
                           │
                ┌──────────┴──────────┐
                │                     │
                │ N                   │ N
         ┌──────▼──────┐       ┌─────▼──────┐
         │   CARTS     │       │  HOA_DON   │
         │ (Giỏ hàng)  │       │ (Đơn hàng)│
         └──────┬──────┘       └─────┬──────┘
                │ 1                  │ 1
                │                    │
                │ N                  │ N
        ┌───────▼────────┐   ┌───────▼─────────┐
        │  CART_ITEMS    │   │ HOA_DON_CHI_TIET│
        │ (Sản phẩm     │   │ (Sản phẩm       │
        │  trong giỏ)    │   │  trong đơn)      │
        └────────┬───────┘   └────────┬─────────┘
                 │ N                  │ N
                 │                    │
                 │  1                 │  1
        ┌────────▼─────┐              │
        │  SAN_PHAM    │◄─────────────┘
        │ (Sản phẩm   │
        │   cha)       │
        └────┬───┬─────┘
             │   │
        ┌────┘   └─────┐
        │ 1            │ 1
        │ N            │ N
  ┌─────▼─────┐  ┌─────▼──────┐
  │ DANH_MUC  │  │SAN_PHAM_   │
  │ (Loại)    │  │CHI_TIET    │──►MAU_SAC (1:N)
  └───────────┘  │ (Biến thể) │──►KICH_THUOC (1:N)
                 └────────────┘
```

## Chi tiết từng bảng

### 1. `users` — Người dùng

| Cột                | Kiểu                | Ràng buộc                                |
|--------------------|---------------------|------------------------------------------|
| `id`               | INT IDENTITY        | PK                                       |
| `full_name`        | NVARCHAR(100)       | NOT NULL                                 |
| `email`            | NVARCHAR(100)       | NOT NULL **UNIQUE**                      |
| `password_hash`    | NVARCHAR(255)       | NOT NULL (BCrypt)                        |
| `phone`            | NVARCHAR(20)        | NULL                                     |
| `address`          | NVARCHAR(255)       | NULL                                     |
| `role`             | NVARCHAR(20)        | CHECK: ADMIN / STAFF / CUSTOMER          |
| `status`           | NVARCHAR(20)        | CHECK: ACTIVE / LOCKED                   |
| `created_at`       | DATETIME2           | DEFAULT SYSDATETIME()                    |

**Quan hệ:**
- 1 — N với `carts` (mỗi user có 1 cart)
- 1 — N với `hoa_don`

---

### 2. `danh_muc` — Danh mục sản phẩm

| Cột            | Kiểu            | Ràng buộc                          |
|----------------|-----------------|------------------------------------|
| `id`           | INT IDENTITY    | PK                                 |
| `name`         | NVARCHAR(100)   | NOT NULL                           |
| `description`  | NVARCHAR(500)   | NULL                               |
| `status`       | NVARCHAR(20)    | CHECK: ACTIVE / INACTIVE           |
| `created_at`   | DATETIME2       | DEFAULT SYSDATETIME()              |

**Quan hệ:** 1 — N với `san_pham` (FK từ `san_pham.category_id`)

---

### 3. `mau_sac` — Màu sắc

| Cột       | Kiểu          | Ràng buộc                |
|-----------|---------------|--------------------------|
| `id`      | INT IDENTITY  | PK                       |
| `name`    | NVARCHAR(50)  | NOT NULL                 |
| `status`  | NVARCHAR(20)  | CHECK: ACTIVE / INACTIVE |

**Quan hệ:** 1 — N với `san_pham_chi_tiet`

---

### 4. `kich_thuoc` — Kích thước

| Cột          | Kiểu          | Ràng buộc                |
|--------------|---------------|--------------------------|
| `id`         | INT IDENTITY  | PK                       |
| `name`       | NVARCHAR(20)  | NOT NULL                 |
| `sort_order` | INT           | DEFAULT 0                |
| `status`     | NVARCHAR(20)  | CHECK: ACTIVE / INACTIVE |

**Quan hệ:** 1 — N với `san_pham_chi_tiet`

---

### 5. `san_pham` — Sản phẩm cha

| Cột           | Kiểu            | Ràng buộc                                 |
|---------------|-----------------|-------------------------------------------|
| `id`          | INT IDENTITY    | PK                                        |
| `category_id` | INT             | **FK → `danh_muc.id`**                    |
| `name`        | NVARCHAR(150)   | NOT NULL                                  |
| `description` | NVARCHAR(MAX)   | NULL                                      |
| `base_price`  | DECIMAL(18,2)   | CHECK ≥ 0                                 |
| `image`       | NVARCHAR(500)   | NULL                                      |
| `status`      | NVARCHAR(20)    | CHECK: ACTIVE / INACTIVE                  |
| `created_at`  | DATETIME2       | DEFAULT SYSDATETIME()                     |

**Quan hệ:**
- N — 1 với `danh_muc`
- 1 — N với `san_pham_chi_tiet`

---

### 6. `san_pham_chi_tiet` — Biến thể (SKU)

| Cột          | Kiểu            | Ràng buộc                                       |
|--------------|-----------------|-------------------------------------------------|
| `id`         | INT IDENTITY    | PK                                              |
| `product_id` | INT             | **FK → `san_pham.id`**                          |
| `color_id`   | INT             | **FK → `mau_sac.id`**                           |
| `size_id`    | INT             | **FK → `kich_thuoc.id`**                        |
| `sku`        | NVARCHAR(50)    | **UNIQUE**                                      |
| `price`      | DECIMAL(18,2)   | NULL — nếu NULL, lấy `base_price` của cha      |
| `quantity`   | INT             | CHECK ≥ 0                                       |
| `image`      | NVARCHAR(500)   | NULL                                            |
| `status`     | NVARCHAR(20)    | CHECK: ACTIVE / INACTIVE                        |

**UNIQUE constraint:** `(product_id, color_id, size_id)` — không trùng biến thể.

**Quan hệ:**
- N — 1 với `san_pham`, `mau_sac`, `kich_thuoc`
- 1 — N với `cart_items` (qua product_id — logic code)
- 1 — N với `hoa_don_chi_tiet`

---

### 7. `carts` — Header giỏ hàng (1 cart / user)

| Cột          | Kiểu        | Ràng buộc                              |
|--------------|-------------|----------------------------------------|
| `user_id`    | INT         | PK, **FK → `users.id` ON DELETE CASCADE** |
| `updated_at` | DATETIME2   | DEFAULT SYSDATETIME()                  |

---

### 8. `cart_items` — Sản phẩm trong giỏ

| Cột            | Kiểu           | Ràng buộc                                |
|----------------|----------------|------------------------------------------|
| `cart_user_id` | INT            | PK, FK → `carts.user_id` ON DELETE CASCADE |
| `product_id`   | INT            | PK, FK → `san_pham.id` ON DELETE CASCADE |
| `product_name` | NVARCHAR(255)  | NOT NULL (snapshot tên tại thời điểm add) |
| `product_image`| NVARCHAR(500)  | NULL                                     |
| `price`        | DECIMAL(18,2)  | CHECK ≥ 0                                |
| `quantity`     | INT            | CHECK > 0                                |

**Quan hệ:** N — 1 với `carts`, N — 1 với `san_pham`

---

### 9. `hoa_don` — Đơn hàng

| Cột                | Kiểu            | Ràng buộc                                            |
|--------------------|-----------------|------------------------------------------------------|
| `id`               | INT IDENTITY    | PK                                                   |
| `user_id`          | INT             | **FK → `users.id`**                                  |
| `receiver_name`    | NVARCHAR(100)   | NOT NULL                                             |
| `receiver_phone`   | NVARCHAR(20)    | NOT NULL                                             |
| `receiver_address` | NVARCHAR(255)   | NOT NULL                                             |
| `note`             | NVARCHAR(500)   | NULL                                                 |
| `total_amount`     | DECIMAL(18,2)   | CHECK ≥ 0                                            |
| `payment_method`   | NVARCHAR(20)    | CHECK: COD / BANK_TRANSFER                           |
| `order_status`     | NVARCHAR(20)    | CHECK: PENDING / CONFIRMED / SHIPPING / FINISH / CANCELLED |
| `created_at`       | DATETIME2       | DEFAULT SYSDATETIME()                                |
| `updated_at`       | DATETIME2       | DEFAULT SYSDATETIME()                                |

**Quan hệ:** N — 1 với `users`, 1 — N với `hoa_don_chi_tiet`

---

### 10. `hoa_don_chi_tiet` — Sản phẩm trong đơn

| Cột                | Kiểu            | Ràng buộc                                  |
|--------------------|-----------------|--------------------------------------------|
| `id`               | INT IDENTITY    | PK                                         |
| `invoice_id`       | INT             | **FK → `hoa_don.id`**                      |
| `variant_id`       | INT             | **FK → `san_pham_chi_tiet.id`**            |
| `product_name`     | NVARCHAR(150)   | NOT NULL (snapshot)                        |
| `color_name`       | NVARCHAR(50)    | NULL                                       |
| `size_name`        | NVARCHAR(20)    | NULL                                       |
| `product_image`    | NVARCHAR(500)   | NULL                                       |
| `price_at_purchase`| DECIMAL(18,2)   | CHECK ≥ 0 (snapshot giá)                   |
| `quantity`         | INT             | CHECK > 0                                  |
| `line_total`       | DECIMAL(18,2)   | CHECK ≥ 0 (= price × quantity)             |

---

## Ràng buộc & Chuẩn hoá

### Chuẩn hoá
- **1NF**: Mọi cột đều atomic, không có cột lặp.
- **2NF**: Mọi cột không khoá phụ thuộc đầy đủ vào khoá chính.
- **3NF**: Không có phụ thuộc bắc cầu (e.g. `color_name`, `size_name` trong `hoa_don_chi_tiet` là **snapshot** — chấp nhận vi phạm 3NF vì lý do lịch sử đơn hàng).

### Snapshot fields
- `cart_items.product_name`, `cart_items.product_image`, `cart_items.price` — lưu snapshot tại thời điểm thêm vào giỏ.
- `hoa_don_chi_tiet.product_name`, `color_name`, `size_name`, `product_image`, `price_at_purchase` — lưu snapshot tại thời điểm mua (không đổi khi sản phẩm thay đổi sau).

### Bảo toàn tham chiếu (Referential Integrity)
- Khi xoá `users` → cascade xoá `carts` → cascade xoá `cart_items`.
- Khi xoá `san_pham` → cascade xoá `cart_items`.
- Không cho xoá `danh_muc` nếu còn `san_pham` tham chiếu.
- Không cho xoá `users` nếu còn `hoa_don` (giữ lịch sử).

## Index (đã thêm trong file SQL)

| Index | Bảng | Cột | Mục đích |
|-------|------|-----|----------|
| `idx_san_pham_category` | san_pham | category_id | Filter theo danh mục (TrangChu) |
| `idx_san_pham_status` | san_pham | status | Lọc ACTIVE/INACTIVE |
| `idx_spct_product` | san_pham_chi_tiet | product_id | Lấy biến thể theo SP |
| `idx_spct_sku` | san_pham_chi_tiet | sku | Tra cứu SKU |
| `idx_hoa_don_user` | hoa_don | user_id | Lịch sử mua hàng user |
| `idx_hoa_don_status` | hoa_don | order_status | Lọc đơn theo trạng thái |
| `idx_hoa_don_created` | hoa_don | created_at DESC | Sort đơn mới nhất |
| `idx_hoa_don_chi_tiet_invoice` | hoa_don_chi_tiet | invoice_id | Lấy chi tiết đơn |
| `idx_cart_items_user` | cart_items | cart_user_id | Lấy giỏ của user |