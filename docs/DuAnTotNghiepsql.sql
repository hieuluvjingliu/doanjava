CREATE DATABASE SD2001_DATN_DEMO;
GO

USE SD2001_DATN_DEMO;
GO

-- =========================
-- 1. Bảng users
-- =========================
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password_hash  NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20),
    address NVARCHAR(255),
    role NVARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT CK_users_role
        CHECK (role IN ('ADMIN', 'CUSTOMER')),

    CONSTRAINT CK_users_status
        CHECK (status IN ('ACTIVE', 'LOCKED'))
);
GO

-- =========================
-- 2. Bảng danh_muc
-- =========================
CREATE TABLE danh_muc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT CK_danh_muc_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
GO

-- =========================
-- 3. Bảng san_pham
-- =========================
CREATE TABLE san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    name NVARCHAR(150) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(18,2) NOT NULL,
    image NVARCHAR(500),
    quantity INT NOT NULL DEFAULT 0,
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_san_pham_danh_muc
        FOREIGN KEY (category_id) REFERENCES danh_muc(id),

    CONSTRAINT CK_san_pham_price_non_negative
        CHECK (price >= 0),

    CONSTRAINT CK_san_pham_quantity_non_negative
        CHECK (quantity >= 0),

    CONSTRAINT CK_san_pham_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
GO

-- =========================
-- 4. Bảng gio_hang
-- =========================
CREATE TABLE gio_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    updated_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_gio_hang_users
        FOREIGN KEY (user_id) REFERENCES users(id),

    CONSTRAINT FK_gio_hang_san_pham
        FOREIGN KEY (product_id) REFERENCES san_pham(id),

    CONSTRAINT CK_gio_hang_quantity_positive
        CHECK (quantity > 0),

    CONSTRAINT UQ_gio_hang_user_product
        UNIQUE (user_id, product_id)
);
GO

-- =========================
-- 5. Bảng hoa_don
-- =========================
CREATE TABLE hoa_don (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    receiver_name NVARCHAR(100) NOT NULL,
    receiver_phone NVARCHAR(20) NOT NULL,
    receiver_address NVARCHAR(255) NOT NULL,
    note NVARCHAR(500),
    total_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    payment_method NVARCHAR(20) NOT NULL DEFAULT 'COD',
    order_status NVARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    updated_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_hoa_don_users
        FOREIGN KEY (user_id) REFERENCES users(id),

    CONSTRAINT CK_hoa_don_total_amount
        CHECK (total_amount >= 0),

    CONSTRAINT CK_hoa_don_payment_method
        CHECK (payment_method IN ('COD')),

    CONSTRAINT CK_hoa_don_order_status
        CHECK (order_status IN (
            'PENDING',
            'CONFIRMED',
            'SHIPPING',
            'FINISH',
            'CANCELLED'
        ))
);
GO

-- =========================
-- 6. Bảng hoa_don_chi_tiet
-- =========================
CREATE TABLE hoa_don_chi_tiet (
    id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id INT NOT NULL,
    product_id INT NOT NULL,
    product_name NVARCHAR(150) NOT NULL,
    product_image NVARCHAR(500),
    price_at_purchase DECIMAL(18,2) NOT NULL,
    quantity INT NOT NULL,
    line_total DECIMAL(18,2) NOT NULL,

    CONSTRAINT FK_hoa_don_chi_tiet_hoa_don
        FOREIGN KEY (invoice_id) REFERENCES hoa_don(id),

    CONSTRAINT FK_hoa_don_chi_tiet_san_pham
        FOREIGN KEY (product_id) REFERENCES san_pham(id),

    CONSTRAINT CK_hoa_don_chi_tiet_price_non_negative
        CHECK (price_at_purchase >= 0),

    CONSTRAINT CK_hoa_don_chi_tiet_quantity_positive
        CHECK (quantity > 0),

    CONSTRAINT CK_hoa_don_chi_tiet_line_total_non_negative
        CHECK (line_total >= 0)
);
GO

-- =========================
-- Dữ liệu mẫu mới: users (Cập nhật theo danh sách)
-- Mật khẩu mặc định đặt là 'password123' cho dễ nhớ
-- =========================
INSERT INTO users(full_name, email, password_hash, phone, address, role, status)
VALUES
(N'Lã Hoàng Trường', 'truonglhtp01035@gmail.com', '123654', '0769069584', N'Hải Phòng', 'ADMIN', 'ACTIVE'),
(N'Lê Việt Cường', 'cuonglvtp01147@gmail.com', '123890', '0869510978', N'Lê Chân, Hải Phòng', 'CUSTOMER', 'ACTIVE'),
(N'Phạm Sơn Minh Khang', 'khangnsmtp00908@gmail.com', '123789', '0392370790', N'Ngô Quyền, Hải Phòng', 'CUSTOMER', 'ACTIVE'),
(N'Phạm Việt Dũng', 'dungpvtp01162@gmail.com', '123456', '0342988500', N'Hải Phòng', 'CUSTOMER', 'ACTIVE'),
(N'Hoàng Long Trung Dũng', 'dunghlttp00960@gmail.com', '123567', '0345945108', N'Hải Phòng', 'CUSTOMER', 'ACTIVE');
GO

-- =========================
-- Dữ liệu mẫu: danh_muc (Chủ đề Bánh)
-- =========================
INSERT INTO danh_muc(name, description, status)
VALUES
(N'Bánh kem sinh nhật', N'Các loại bánh kem phục vụ sinh nhật, kỷ niệm', 'ACTIVE'),
(N'Bánh mì & Bánh mặn', N'Bánh mì tươi, bánh gối và các loại bánh mặn ăn sáng', 'ACTIVE'),
(N'Bánh ngọt tráng miệng', N'Bánh cupcake, mousse, tart ngọt ngào', 'ACTIVE'),
(N'Bánh quy & Hạt', N'Các loại bánh quy khô và hạt dinh dưỡng', 'ACTIVE');
GO

-- =========================
-- Dữ liệu mẫu: san_pham (Chủ đề Bánh)
-- =========================
INSERT INTO san_pham(category_id, name, description, price, image, quantity, status)
VALUES
(1, N'Bánh kem dâu tây kem tươi', N'Bánh gato cốt vani xen kẽ mứt dâu tây tươi ngọt dịu.', 250000, 'https://placehold.co', 2, 'ACTIVE'),
(1, N'Bánh kem socola matcha', N'Sự kết hợp hoàn hảo giữa vị đắng nhẹ của matcha và socola đậm đà.', 180000, 'https://placehold.co', 20, 'ACTIVE'),
(2, N'Bánh mì chà bông sốt kem', N'Bánh mì tươi mềm mịn phủ đầy ruốc heo và sốt kem trứng béo ngậy.', 320000, 'https://placehold.co', 15, 'ACTIVE'),
(2, N'Bánh sừng bò Croissant mặn', N'Bánh sừng bò ngàn lớp thơm mùi bơ Pháp bên trong có nhân phô mai.', 290000, 'https://placehold.co', 10, 'ACTIVE'),
(3, N'Bánh Mousse chanh leo', N'Mousse mát lạnh xốp mịn với vị chua thanh từ cốt chanh leo tự nhiên.', 420000, 'https://placehold.co', 12, 'ACTIVE'),
(3, N'Bánh Tiramisu truyền thống', N'Bánh ngọt nước Ý đượm hương cà phê và rượu nhẹ quyện lớp kem béo.', 350000, 'https://placehold.co', 18, 'ACTIVE'),
(4, N'Mũ quy bơ hạnh nhân', N'Bánh quy nướng giòn rụm thơm lừng mùi bơ, phủ hạt hạnh nhân lát.', 120000, 'https://placehold.co', 30, 'ACTIVE'),
(4, N'Túi bánh ngói hạnh nhân ăn kiêng', N'Bánh ngói mỏng giòn, không đường tinh luyện, tốt cho sức khỏe.', 150000, 'https://placehold.co', 25, 'ACTIVE');
GO

-- =========================
-- Dữ liệu mẫu: hoa_don (Liên kết dựa trên user_id mới)
-- =========================
INSERT INTO hoa_don(
    user_id,
    receiver_name,
    receiver_phone,
    receiver_address,
    note,
    total_amount,
    payment_method,
    order_status
)
VALUES
-- user_id = 2 là Lê Việt Cường
(2, N'Lê Việt Cường', '0869510978', N'Lê Chân, Hải Phòng', N'Giao giờ hành chính', 500000, 'COD', 'PENDING'),
-- user_id = 3 là Phạm Sơn Minh Khang
(3, N'Phạm Sơn Minh Khang', '0392370790', N'Ngô Quyền, Hải Phòng', N'Gọi trước khi giao', 320000, 'COD', 'CONFIRMED');
GO

-- =========================
-- Dữ liệu mẫu: hoa_don_chi_tiet
-- =========================
INSERT INTO hoa_don_chi_tiet(
    invoice_id,
    product_id,
    product_name,
    product_image,
    price_at_purchase,
    quantity,
    line_total
)
VALUES
(1, 1, N'Bánh kem dâu tây kem tươi', 'https://placehold.co', 250000, 2, 500000),
(2, 3, N'Bánh mì chà bông sốt kem', 'https://placehold.co', 320000, 1, 320000);
GO

-- Đơn mẫu số 2 đang CONFIRMED nên giả lập tự động trừ kho 1 sản phẩm bánh mì chà bông sốt kem
UPDATE san_pham
SET quantity = quantity - 1
WHERE id = 3 AND quantity >= 1;
GO

-- =========================
-- Kiểm tra dữ liệu
-- =========================
SELECT * FROM users;
SELECT * FROM danh_muc;
SELECT * FROM san_pham;
SELECT * FROM gio_hang;
SELECT * FROM hoa_don;
SELECT * FROM hoa_don_chi_tiet;
GO
