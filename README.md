# 🛍️ QUYBUU Store — Đồ án Java Web (JSP/Servlet)

Website bán quần áo xây dựng bằng **Java Servlet + JSP** theo mô hình **MVC** với Jakarta EE 10, Apache Tomcat 10.1 và SQL Server.

---

## 📑 Mục lục
1. [Giới thiệu](#-giới-thiệu)
2. [Công nghệ sử dụng](#-công-nghệ-sử-dụng)
3. [Kiến trúc & Cấu trúc dự án](#-kiến-trúc--cấu-trúc-dự-án)
4. [Tính năng](#-tính-năng)
5. [Hướng dẫn cài đặt](#-hướng-dẫn-cài-đặt)
6. [Cấu hình Database](#-cấu-hình-database)
7. [Cách chạy](#-cách-chạy)
8. [Tài khoản demo](#-tài-khoản-demo)
9. [Sơ đồ luồng](#-sơ-đồ-luồng)
10. [Cải tiến nổi bật](#-cải-tiến-nổi-bật)
11. [Đóng góp](#-đóng-góp)

---

## 🎯 Giới thiệu

**QUYBUU Store** là đồ án môn học Java Web với mục tiêu xây dựng website thương mại điện tử đầy đủ chức năng:
- **Phía khách hàng**: duyệt sản phẩm, đăng ký/đăng nhập, giỏ hàng, đặt hàng, lịch sử mua hàng.
- **Phía quản trị**: dashboard thống kê, quản lý đơn hàng, sản phẩm, danh mục, kích thước, màu sắc, người dùng.

---

## 🛠 Công nghệ sử dụng

| Hạng mục        | Công nghệ                                       |
|-----------------|-------------------------------------------------|
| Ngôn ngữ        | Java 21 (JDK 21)                                |
| Web framework   | Jakarta Servlet 6.0 / JSP                        |
| View Engine     | JSP + JSTL                                       |
| CSDL            | Microsoft SQL Server (JDBC driver `mssql-jdbc`)  |
| Web server      | Apache Tomcat 10.1                                |
| Front-end       | Bootstrap 5.3, Bootstrap Icons, Mazer Template    |
| Build tool      | Eclipse IDE for Java EE (`Servers` view)         |
| JavaScript      | Native ES6 (browser modules)                      |

---

## 🏗 Kiến trúc & Cấu trúc dự án

Mô hình **MVC 3 lớp** + Service Layer:

```
src/main/java/
├── controller/         # Servlet (điều phối, đọc param, forward view)
│   ├── admin/         # Servlet khu vực /admin/*
│   └── *.java          # Servlet public: TrangChuServlet, LoginServlet, RegisterServlet, ...
├── service/            # Business logic
│   ├── AuthService     # login, register, validation
│   ├── CartService     # giỏ hàng (in-memory + DB)
│   ├── OrderService    # quản lý đơn hàng + phân trang + tổng tiền
│   └── ProductService  # CRUD + phân trang + tìm kiếm
├── dao/                # Data Access Object (PreparedStatement)
├── model/              # POJO entity
└── utils/              # Constants, ConnectDB (JDBC helper)
```

```
src/main/webapp/
├── WEB-INF/
│   ├── web.xml                    # Cấu hình web
│   ├── lib/                       # JDBC driver + JSTL
│   ├── tags/                      # Custom JSP tags (safeImage)
│   └── views/
│       ├── admin/                 # Trang quản trị (/admin/*)
│       │   ├── layout.jsp         # Layout chính (sidebar/topbar)
│       │   ├── orders.jsp         # Danh sách đơn hàng + PHÂN TRANG
│       │   ├── order/             # Chi tiết đơn
│       │   ├── product/           # Sản phẩm + modal CRUD
│       │   ├── user/              # Users + empty state
│       │   ├── danhmuc/           # Categories
│       │   ├── color/, size/, variant/
│       │   └── dashboard/
│       └── client/
│           └── pages/
├── assets/             # Bootstrap, Mazer template, images
├── login.jsp
├── register.jsp
├── header.jsp / footer.jsp
└── index.jsp
```

---

## ✨ Tính năng

### 👤 Phía khách hàng
- ✅ Đăng ký / đăng nhập (validation server-side + client-side)
- ✅ Xem sản phẩm theo danh mục, chi tiết sản phẩm
- ✅ Giỏ hàng (session + DB khi đăng nhập, merge khi login)
- ✅ Đặt hàng (COD / chuyển khoản)
- ✅ Lịch sử mua hàng
- ✅ Validation thân thiện (email format, password ≥ 6 ký tự, SĐT Việt Nam)

### 🛠 Phía quản trị (`/admin/*`)
- ✅ **Dashboard**: tổng quan doanh thu, đơn hàng, khách hàng
- ✅ **Quản lý đơn hàng**: danh sách **có phân trang**, cập nhật trạng thái (PENDING → CONFIRMED → SHIPPING → FINISH/CANCELLED)
- ✅ **Chi tiết đơn**: hiển thị thông tin người nhận + sản phẩm
- ✅ **Quản lý sản phẩm**: thêm/sửa/xóa + upload ảnh, badge tồn kho (Hết/Thấp/Đủ)
- ✅ **Quản lý biến thể**: size + màu + số lượng
- ✅ **Quản lý danh mục / kích thước / màu sắc / người dùng**

### 🔔 UX improvements
- ✅ Flash message (success/error) hiển thị toast-style ở góc trên phải
- ✅ Empty state cho table không có dữ liệu
- ✅ Bootstrap Alert dismissible (auto fade animation)
- ✅ Pagination chuẩn Bootstrap với prev/next + first/last

---

## 📥 Hướng dẫn cài đặt

### Yêu cầu
- **JDK 21** trở lên
- **Apache Tomcat 10.1**
- **SQL Server 2019+** (hoặc SQL Server Express)
- **Eclipse IDE for Java EE Developers** (khuyến nghị) — hoặc IDE bất kỳ hỗ trợ Jakarta EE

### Bước 1 — Clone project
```bash
git clone <repo-url>
```
Mở Eclipse → `File` → `Import` → `Existing Projects into Workspace` → chọn folder `doanquanaoquybuu`.

### Bước 2 — Import database
Mở SQL Server Management Studio → chạy file `sql/QL_QUYBUU.sql` để tạo database + dữ liệu mẫu.

### Bước 3 — Cấu hình JDBC
Sửa `src/main/java/utils/ConnectDB.java`:
```java
private static String DB_URL  = "jdbc:sqlserver://localhost:1433;"
                             + "databaseName=QL_QUYBUU;"
                             + "user=sa;password=YOUR_PASSWORD;"
                             + "encrypt=true;trustServerCertificate=true";
```

### Bước 4 — Add Tomcat vào Eclipse
`Window` → `Preferences` → `Server` → `Runtime Environments` → `Add` → chọn Apache Tomcat 10.1.

### Bước 5 — Chạy project
- Trong view `Servers`: chuột phải Tomcat → `Add and Remove...` → thêm `doanquanaoquybuu`.
- Chuột phải Tomcat → `Start` (hoặc `Debug`).
- Truy cập: `http://localhost:8080/doanquanaoquybuu/`

---

## 🗄 Cấu hình Database

Schema chính (xem chi tiết trong `sql/QL_QUYBUU.sql`):

| Bảng              | Mô tả                                           |
|-------------------|-------------------------------------------------|
| `users`           | Tài khoản (id, email, password_hash, role, status) |
| `san_pham`        | Sản phẩm                                         |
| `danh_muc`        | Danh mục sản phẩm                                |
| `mau_sac`         | Màu sắc                                          |
| `kich_thuoc`      | Kích thước                                        |
| `san_pham_chi_tiet` | Biến thể sản phẩm (variant + tồn kho)           |
| `hoa_don`         | Đơn hàng                                         |
| `hoa_don_chi_tiet` | Chi tiết đơn hàng                                |
| `cart_items`      | Giỏ hàng (lưu khi user đăng nhập)               |

---

## ▶️ Cách chạy

Sau khi cài đặt xong:

| Bước | Hành động                                      |
|------|------------------------------------------------|
| 1    | Start SQL Server (đảm bảo service đang chạy)    |
| 2    | Mở Eclipse, khởi động Apache Tomcat 10.1        |
| 3    | Truy cập `http://localhost:8080/doanquanaoquybuu` |
| 4    | Đăng nhập với tài khoản admin (xem bên dưới)     |

---

## 🔑 Tài khoản demo

| Email                  | Mật khẩu | Role   | Ghi chú            |
|------------------------|----------|--------|---------------------|
| `admin@quybuu.vn`      | `admin123` | ADMIN  | Toàn quyền quản trị |
| `staff@quybuu.vn`      | `staff123` | STAFF  | Xem + cập nhật đơn  |
| `khach@quybuu.vn`      | `khach123` | CUSTOMER | Tài khoản khách mẫu |

> ⚠️ **Lưu ý bảo mật (môn học)**: Password lưu plain-text trong DB, không phù hợp với production.

---

## 🔁 Sơ đồ luồng

### Luồng đăng nhập
```
Client → /login (POST email, password)
       → LoginServlet.doPost()
       → AuthService.login()
         → UserDAO.login() [SELECT * FROM users WHERE email=? AND password_hash=?]
       → OK → set session "LOGIN_USER" → redirect:
         ADMIN/STAFF → /admin/dashboard
         CUSTOMER    → /trang-chu
       → FAIL → setAttribute("error") → forward /login.jsp
```

### Luồng đặt hàng
```
Client /gio-hang → /thanh-toan (POST)
  → ThanhToanServlet
    → HoaDonDAO.createHoaDon() + createHoaDonChiTiet()
    → updateStock() từng variant (quantity -= qty)
    → clearCart() (CartService + CartDAO)
    → redirect /lich-su-mua-hang
```

### Luồng admin cập nhật đơn
```
Admin chọn /admin/orders?action=detail&id=X
  → AdminOrderServlet.handleDetail()
    → OrderService.getOrderDetail() + getOrderItems()
  → forward /WEB-INF/views/admin/order/order-detail.jsp

Admin chọn status mới (form auto-submit)
  → AdminOrderServlet.handleUpdateStatus()
    → OrderService.updateOrderStatus()
    → session.setAttribute("flashSuccess", "...")
    → redirect /admin/orders  (flash message hiển thị ở layout.jsp)
```

### Phân trang
```
Client /admin/orders?page=2
  → AdminOrderServlet.doGet()
    → OrderService.getOrdersByPage(2, 10)
      → HoaDonDAO.getByPage(10, 10)  [OFFSET 10 FETCH NEXT 10]
    → forward orders.jsp với currentPage / totalPages / totalOrders
```

---

## 🚀 Cải tiến nổi bật (so với bản gốc)

| Cải tiến                      | Mô tả                                                                  |
|-------------------------------|------------------------------------------------------------------------|
| **Constants class**           | Gom role, status, session keys — tránh magic string rải rác            |
| **Service Layer**             | `AuthService`, `OrderService`, `ProductService` — tách logic khỏi DAO  |
| **Pagination**                | Đơn hàng phân trang (10/trang), `OFFSET … FETCH NEXT` chuẩn SQL Server |
| **Validation email/SĐT/Pass** | `AuthService.validateXxx(...)` + client-side Bootstrap validation       |
| **Flash message**             | Toast-style alert ở góc trên phải, tự đóng bằng Bootstrap fade         |
| **Empty state**               | Table trống → icon + thông báo thay vì trống không                       |
| **Bug fix NPE**               | `order.receiverAddress.length()` → check null trước                     |
| **Dashboard stats**           | Dùng `OrderService.calcTotalRevenue` — không hard-code logic ở servlet |

---

## 👥 Đóng góp (Team members)

Điền tên thành viên + phần phụ trách:

| STT | Họ và tên        | MSSV    | Phụ trách         |
|-----|------------------|---------|-------------------|
| 1   | Nguyễn Văn A     | SV001   | Backend (DAO/Service) |
| 2   | Trần Thị B       | SV002   | Frontend (JSP/UI)     |
| 3   | Lê Văn C         | SV003   | Database + Diagram   |

---

## 📝 Giáo viên hướng dẫn

GVHD: `Nguyễn Văn Giáo Viên`

---

## 📄 License

This project is for educational purposes only.
