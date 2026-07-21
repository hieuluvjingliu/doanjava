CREATE DATABASE QL_QUYBUU;
GO

USE QL_QUYBUU;
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
        CHECK (role IN ('ADMIN', 'STAFF', 'CUSTOMER')),

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
-- 3. Bảng mau_sac
-- =========================
CREATE TABLE mau_sac (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT CK_mau_sac_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
GO

-- =========================
-- 4. Bảng kich_thuoc
-- =========================
CREATE TABLE kich_thuoc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(20) NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT CK_kich_thuoc_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
GO

-- =========================
-- 5. Bảng san_pham (Sản phẩm cha)
-- =========================
CREATE TABLE san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    name NVARCHAR(150) NOT NULL,
    description NVARCHAR(MAX),
    base_price DECIMAL(18,2) NOT NULL,
    image NVARCHAR(500),
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_san_pham_danh_muc
        FOREIGN KEY (category_id) REFERENCES danh_muc(id),

    CONSTRAINT CK_san_pham_price_non_negative
        CHECK (base_price >= 0),

    CONSTRAINT CK_san_pham_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
GO

-- =========================
-- 6. Bảng san_pham_chi_tiet (Biến thể - SKU)
-- =========================
CREATE TABLE san_pham_chi_tiet (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    color_id INT NOT NULL,
    size_id INT NOT NULL,
    sku NVARCHAR(50) UNIQUE,
    price DECIMAL(18,2), -- Nếu NULL, lấy base_price của sản phẩm cha
    quantity INT NOT NULL DEFAULT 0,
    image NVARCHAR(500),
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT FK_san_pham_chi_tiet_san_pham
        FOREIGN KEY (product_id) REFERENCES san_pham(id),
        
    CONSTRAINT FK_san_pham_chi_tiet_mau_sac
        FOREIGN KEY (color_id) REFERENCES mau_sac(id),
        
    CONSTRAINT FK_san_pham_chi_tiet_kich_thuoc
        FOREIGN KEY (size_id) REFERENCES kich_thuoc(id),

    CONSTRAINT CK_san_pham_chi_tiet_quantity_non_negative
        CHECK (quantity >= 0),

    CONSTRAINT CK_san_pham_chi_tiet_status
        CHECK (status IN ('ACTIVE', 'INACTIVE')),
        
    CONSTRAINT UQ_san_pham_chi_tiet_unique_variant
        UNIQUE (product_id, color_id, size_id)
);
GO

-- =========================
-- 7. Bảng gio_hang
-- =========================
CREATE TABLE gio_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    variant_id INT NOT NULL,
    quantity INT NOT NULL,
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    updated_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_gio_hang_users
        FOREIGN KEY (user_id) REFERENCES users(id),

    CONSTRAINT FK_gio_hang_san_pham_chi_tiet
        FOREIGN KEY (variant_id) REFERENCES san_pham_chi_tiet(id),

    CONSTRAINT CK_gio_hang_quantity_positive
        CHECK (quantity > 0),

    CONSTRAINT UQ_gio_hang_user_variant
        UNIQUE (user_id, variant_id)
);
GO

-- =========================
-- 8. Bảng hoa_don
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
        CHECK (payment_method IN ('COD', 'BANK_TRANSFER')),

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
-- 9. Bảng hoa_don_chi_tiet
-- =========================
CREATE TABLE hoa_don_chi_tiet (
    id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id INT NOT NULL,
    variant_id INT NOT NULL,
    product_name NVARCHAR(150) NOT NULL,
    color_name NVARCHAR(50),
    size_name NVARCHAR(20),
    product_image NVARCHAR(500),
    price_at_purchase DECIMAL(18,2) NOT NULL,
    quantity INT NOT NULL,
    line_total DECIMAL(18,2) NOT NULL,

    CONSTRAINT FK_hoa_don_chi_tiet_hoa_don
        FOREIGN KEY (invoice_id) REFERENCES hoa_don(id),

    CONSTRAINT FK_hoa_don_chi_tiet_san_pham_chi_tiet
        FOREIGN KEY (variant_id) REFERENCES san_pham_chi_tiet(id),

    CONSTRAINT CK_hoa_don_chi_tiet_price_non_negative
        CHECK (price_at_purchase >= 0),

    CONSTRAINT CK_hoa_don_chi_tiet_quantity_positive
        CHECK (quantity > 0),

    CONSTRAINT CK_hoa_don_chi_tiet_line_total_non_negative
        CHECK (line_total >= 0)
);
GO

-- =========================
-- DỮ LIỆU MẪU (SEED DATA) 
-- =========================

-- 1. Users
INSERT INTO users(full_name, email, password_hash, phone, address, role, status)
VALUES
(N'Lã Hoàng Trường', 'truonglhtp01035@gmail.com', '123654', '0769069584', N'Hải Phòng', 'ADMIN', 'ACTIVE'),
(N'Lê Việt Cường', 'cuonglvtp01147@gmail.com', '123890', '0869510978', N'Lê Chân, Hải Phòng', 'CUSTOMER', 'ACTIVE'),
(N'Phạm Sơn Minh Khang', 'khangnsmtp00908@gmail.com', '123789', '0392370790', N'Ngô Quyền, Hải Phòng', 'CUSTOMER', 'ACTIVE'),
(N'Nhân Viên Mẫu', 'nhanvien@quybuu.com', '123123', '0123456789', N'Hải Phòng', 'STAFF', 'ACTIVE');
GO

-- 2. Danh mục
INSERT INTO danh_muc(name, description, status)
VALUES
(N'Áo thun Anime', N'Các mẫu áo thun in hình nhân vật Anime nổi tiếng', 'ACTIVE'),
(N'Áo Hoodie', N'Áo Hoodie ấm áp phong cách Manga', 'ACTIVE'),
(N'Cosplay & Phụ kiện', N'Trang phục và phụ kiện Cosplay chuyên nghiệp', 'ACTIVE'),
(N'Quần & Chân váy', N'Quần jogger, chân váy phong cách học đường Nhật Bản', 'ACTIVE');
GO

-- 3. Màu sắc
INSERT INTO mau_sac(name, status)
VALUES
(N'Đen', 'ACTIVE'),
(N'Trắng', 'ACTIVE'),
(N'Đỏ', 'ACTIVE'),
(N'Xanh Navy', 'ACTIVE');
GO

-- 4. Kích thước
INSERT INTO kich_thuoc(name, sort_order, status)
VALUES
('S', 1, 'ACTIVE'),
('M', 2, 'ACTIVE'),
('L', 3, 'ACTIVE'),
('XL', 4, 'ACTIVE');
GO

-- 5. Sản phẩm (Sản phẩm cha)
INSERT INTO san_pham(category_id, name, description, base_price, image, status)
VALUES
(1, N'Áo thun Naruto Cửu Vĩ', N'Áo thun cotton 100% in hình Naruto dạng Cửu Vĩ sắc nét.', 250000, 'naruto_shirt.jpg', 'ACTIVE'),
(2, N'Áo Hoodie Jujutsu Kaisen', N'Áo hoodie nỉ bông in logo trường Jujutsu, dày dặn, form rộng.', 450000, 'jjk_hoodie.jpg', 'ACTIVE'),
(3, N'Áo khoác Akatsuki', N'Áo khoác tổ chức Akatsuki chuẩn form cosplay.', 350000, 'akatsuki_cloak.jpg', 'ACTIVE'),
(4, N'Quần Jogger One Piece', N'Quần jogger thể thao logo băng Mũ Rơm.', 280000, 'onepiece_jogger.jpg', 'ACTIVE');
GO

-- 6. Sản phẩm chi tiết (Biến thể)
-- SP 1: Áo thun Naruto (Đen - M, L), (Trắng - M)
INSERT INTO san_pham_chi_tiet(product_id, color_id, size_id, sku, price, quantity, status)
VALUES
(1, 1, 2, 'TS-NAR-BLK-M', NULL, 50, 'ACTIVE'), -- Đen, M
(1, 1, 3, 'TS-NAR-BLK-L', NULL, 30, 'ACTIVE'), -- Đen, L
(1, 2, 2, 'TS-NAR-WHT-M', NULL, 20, 'ACTIVE'); -- Trắng, M

-- SP 2: Áo Hoodie JJK (Đen - L, XL)
INSERT INTO san_pham_chi_tiet(product_id, color_id, size_id, sku, price, quantity, status)
VALUES
(2, 1, 3, 'HD-JJK-BLK-L', NULL, 15, 'ACTIVE'), -- Đen, L
(2, 1, 4, 'HD-JJK-BLK-XL', NULL, 10, 'ACTIVE'); -- Đen, XL

-- SP 3: Áo khoác Akatsuki (Đỏ - M, L)
INSERT INTO san_pham_chi_tiet(product_id, color_id, size_id, sku, price, quantity, status)
VALUES
(3, 3, 2, 'CO-AKA-RED-M', NULL, 5, 'ACTIVE'), -- Đỏ, M
(3, 3, 3, 'CO-AKA-RED-L', NULL, 8, 'ACTIVE'); -- Đỏ, L
GO

-- 7. Hóa đơn
INSERT INTO hoa_don(
    user_id, receiver_name, receiver_phone, receiver_address, note, total_amount, payment_method, order_status
)
VALUES
-- user_id = 2 mua
(2, N'Lê Việt Cường', '0869510978', N'Lê Chân, Hải Phòng', N'Giao giờ hành chính', 250000, 'COD', 'PENDING'),
-- user_id = 3 mua
(3, N'Phạm Sơn Minh Khang', '0392370790', N'Ngô Quyền, Hải Phòng', N'Gọi trước khi giao', 450000, 'BANK_TRANSFER', 'CONFIRMED');
GO

-- 8. Hóa đơn chi tiết
INSERT INTO hoa_don_chi_tiet(
    invoice_id, variant_id, product_name, color_name, size_name, product_image, price_at_purchase, quantity, line_total
)
VALUES
-- Hóa đơn 1 mua 1 Áo thun Naruto Đen M (Giá 250000)
(1, 1, N'Áo thun Naruto Cửu Vĩ', N'Đen', 'M', 'naruto_shirt.jpg', 250000, 1, 250000),
-- Hóa đơn 2 mua 1 Áo Hoodie JJK Đen L (Giá 450000)
(2, 4, N'Áo Hoodie Jujutsu Kaisen', N'Đen', 'L', 'jjk_hoodie.jpg', 450000, 1, 450000);
GO

-- Trừ kho cho hóa đơn đã CONFIRMED (Hóa đơn 2 mua variant_id 4)
UPDATE san_pham_chi_tiet
SET quantity = quantity - 1
WHERE id = 4 AND quantity >= 1;
GO

-- =========================
-- KIỂM TRA DỮ LIỆU
-- =========================
SELECT * FROM users;
SELECT * FROM danh_muc;
SELECT * FROM mau_sac;
SELECT * FROM kich_thuoc;
SELECT * FROM san_pham;
SELECT * FROM san_pham_chi_tiet;
SELECT * FROM gio_hang;
SELECT * FROM hoa_don;
SELECT * FROM hoa_don_chi_tiet;
GO
