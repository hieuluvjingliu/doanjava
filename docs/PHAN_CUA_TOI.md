# Tài liệu luồng code - Phần phụ trách của tôi

Tài liệu này trình bày luồng xử lý của **4 chức năng phía khách hàng** do tôi phụ trách, đi từ **UI → URL → Filter → Controller → Service → DAO → Database → View**, kèm theo đoạn mã minh họa thực tế từ dự án.

## Phạm vi chức năng

| # | Chức năng | URL | Servlet | Service chính |
|---|-----------|-----|---------|----------------|
| 1 | Tìm kiếm sản phẩm | `GET /trang-chu?keyword={từ khóa}` | `TrangChuServlet` | `CatalogService` |
| 2 | Chi tiết sản phẩm | `GET /chi-tiet?id={productId}` | `ChiTietServlet` | `CatalogService`, `VariantService`, `ColorService`, `SizeService` |
| 3 | Đặt hàng / Thanh toán | `POST /thanh-toan` | `ThanhToanServlet` | `CheckoutService` |
| 4 | Lịch sử mua hàng | `GET /lich-su-mua-hang` | `LichSuMuaHangServlet` | `CheckoutService` |

---

## Kiến trúc tổng quan (nhắc lại)

```
Browser (JSP + JSTL + Bootstrap 5)
        │ HTTP request/response
        ▼
Filter Chain
  EncodingFilter → GlobalErrorHandlerFilter
        │
        ▼
Controller (Servlet)           ← @WebServlet("/...")
        │ gọi service
        ▼
Service (Business Logic)       ← validate, điều phối nhiều DAO
        │ gọi DAO
        ▼
DAO (PreparedStatement + JDBC)
        │ truy vấn
        ▼
SQL Server (database QL_QUYBUU)
        │
        ▼
View (JSP render HTML)
```

**Quy ước:**
- Servlet dùng annotation `@WebServlet("/url")` để khai báo URL (không cấu hình trong `web.xml`).
- Mọi đường dẫn phía client bắt đầu bằng contextPath `/doanquanaoquybuu`.
- Servlet đọc tham số → gọi Service → đặt attribute vào request → forward sang JSP.
- Toàn bộ request/response dùng UTF-8 nhờ `EncodingFilter`.

---

## Chức năng 1 - Tìm kiếm sản phẩm

### 1.1. UI người dùng thấy

- Trên header có **icon kính lúp** → click để mở ô input tìm kiếm.
- Gõ từ khóa → nhấn Enter → form submit → URL trở thành `?keyword={từ khóa}`.
- Kết quả hiển thị ngay trên trang chủ với tiêu đề "KẾT QUẢ TÌM KIẾM" và subtitle "Từ khóa: \"{từ khóa}\"".

### 1.2. URL

```
GET /doanquanaoquybuu/trang-chu?keyword=áo%20thun
```

Form trong `header.jsp` gửi request `GET` với tham số `keyword`.

### 1.3. Luồng xử lý

#### Bước 1: Filter chain
- `EncodingFilter`: thiết lập `UTF-8` cho request/response.
- `GlobalErrorHandlerFilter`: bọc try-catch để bắt lỗi toàn cục.

#### Bước 2: `TrangChuServlet.doGet()`

Tomcat khớp URL `/trang-chu` với `@WebServlet("/trang-chu")` rồi gọi `doGet()`.

Servlet đọc tham số `keyword`:

```java
String keywordParam = req.getParameter("keyword");
```

#### Bước 3: Gọi `CatalogService.getCatalog()`

Servlet phát hiện `keywordParam` khác null và không rỗng, gọi:

```java
List<SanPham> listNewProducts = catalogService.getCatalog(null, "áo thun");
```

Trong `CatalogService`:

```java
public List<SanPham> getCatalog(String categoryParam, String keywordParam) {
    if (categoryParam != null && !categoryParam.isBlank()) {
        // Người khác phụ trách - lọc theo danh mục
        try {
            int cid = Integer.parseInt(categoryParam);
            return sanPhamDAO.getByCategoryId(cid);
        } catch (NumberFormatException ex) {
            return sanPhamDAO.getAll();
        }
    }
    if (keywordParam != null && !keywordParam.isBlank()) {
        // PHẦN CỦA TÔI - tìm kiếm theo từ khóa
        return sanPhamDAO.searchByKeyword(keywordParam);
    }
    return sanPhamDAO.getAll();
}
```

#### Bước 4: `SanPhamDAO.searchByKeyword()`

Thực thi câu SQL với `PreparedStatement`:

```java
public List<SanPham> searchByKeyword(String keyword) {
    String sql = "SELECT * FROM san_pham WHERE name LIKE ? OR description LIKE ?";
    String pattern = "%" + keyword + "%";
    // ps.setString(1, pattern);
    // ps.setString(2, pattern);
    // rs = ps.executeQuery();
    // ... map từng row thành SanPham
    return list;
}
```

SQL thực tế được thực thi:

```sql
SELECT * FROM san_pham
WHERE name LIKE '%áo thun%' OR description LIKE '%áo thun%'
```

#### Bước 5: Servlet đặt attribute và forward

```java
req.setAttribute("listDanhMuc", listDanhMuc);
req.setAttribute("listNewProducts", listNewProducts);
req.setAttribute("pageTitle", "KẾT QUẢ TÌM KIẾM");
req.setAttribute("pageSubtitle", "Từ khóa: \"" + keywordParam + "\"");
req.getRequestDispatcher("/index.jsp").forward(req, resp);
```

#### Bước 6: JSP render

`index.jsp` render danh sách sản phẩm khớp với tiêu đề trang.

### 1.4. Điểm cần nhấn mạnh khi bảo vệ

- **Tại sao dùng `LIKE '%keyword%'`** thay vì `=`? Vì muốn tìm chuỗi con (chứa), không phải exact match.
- **Tại sao dùng `OR`?** Để tìm trong cả tên lẫn mô tả, tăng khả năng khớp.
- **Tại sao wildcard ở cả 2 phía (`%keyword%`)?** Cho phép khớp ở bất kỳ vị trí nào trong chuỗi.
- **Phân biệt với lọc danh mục**: lọc danh mục dùng `WHERE category_id = ?` (exact), còn tìm kiếm dùng `LIKE` (substring).
- **Hai chức năng cùng servlet**: phân biệt qua sự tồn tại của `category` vs `keyword` trong URL.

### 1.5. Câu hỏi bảo vệ thường gặp

**"Tại sao không dùng Full-Text Search?"**  
Vì SQL Server Full-Text cần cấu hình Full-Text Index riêng và câu truy vấn phức tạp hơn. Với sản phẩm có mô tả ngắn và cỡ dữ liệu nhỏ, `LIKE` đủ dùng.

**"Có chống SQL injection không?"**  
Có, vì dùng `PreparedStatement` với tham số `?`, dữ liệu được escape tự động.

---

## Chức năng 2 - Chi tiết sản phẩm

### 2.1. UI người dùng thấy

- Từ trang chủ, click vào ảnh hoặc tên sản phẩm → chuyển sang trang chi tiết.
- Trang chi tiết gồm:
  - Ảnh sản phẩm lớn (render qua custom tag `safeImage`).
  - Tên sản phẩm, mô tả.
  - **Dropdown phân loại** (màu + size + tồn kho), ví dụ: "Màu Trắng - Size M (Kho: 15)".
  - Ô nhập số lượng (mặc định 1).
  - Hiển thị giá động theo biến thể đang chọn.
  - Nút "THÊM VÀO GIỎ HÀNG".

### 2.2. URL

```
GET /doanquanaoquybuu/chi-tiet?id=5
```

### 2.3. Luồng xử lý

#### Bước 1: Filter chain
Giống các chức năng khác.

#### Bước 2: `ChiTietServlet.doGet()`

```java
String idStr = req.getParameter("id");
if (idStr == null) {
    resp.sendRedirect(req.getContextPath() + "/trang-chu");
    return;
}
int productId;
try {
    productId = Integer.parseInt(idStr);
} catch (NumberFormatException e) {
    resp.sendRedirect(req.getContextPath() + "/trang-chu");
    return;
}
```

**Lý do kiểm tra kỹ `id`:**
- Nếu thiếu `id` → redirect về trang chủ.
- Nếu `id` không phải số (ví dụ `id=abc`) → bắt `NumberFormatException` → redirect.

#### Bước 3: Lấy thông tin sản phẩm và biến thể

```java
SanPham product = catalogService.getProductById(productId);
if (product == null) {
    resp.sendRedirect(req.getContextPath() + "/trang-chu");
    return;
}
List<SanPhamChiTiet> variants = catalogService.getVariants(productId);
```

Gọi thêm 2 service để lấy danh sách màu/size (dùng để hiển thị tên thay vì ID):

```java
List<MauSac> listMauSac = colorService.getAll();
List<KichThuoc> listKichThuoc = sizeService.getAll();
```

#### Bước 4: Service → DAO

| Lệnh gọi | DAO thực thi | SQL |
|----------|-------------|-----|
| `catalogService.getProductById(id)` | `SanPhamDAO.getById(id)` | `SELECT * FROM san_pham WHERE id = ?` |
| `catalogService.getVariants(id)` | `SanPhamChiTietDAO.getByProductId(id)` | `SELECT * FROM san_pham_chi_tiet WHERE product_id = ?` |
| `colorService.getAll()` | `MauSacDAO.getAll()` | `SELECT * FROM mau_sac` |
| `sizeService.getAll()` | `KichThuocDAO.getAll()` | `SELECT * FROM kich_thuoc ORDER BY sort_order` |

#### Bước 5: Servlet đặt attribute và forward

```java
req.setAttribute("product", product);
req.setAttribute("variants", variants);
req.setAttribute("listMauSac", listMauSac);
req.setAttribute("listKichThuoc", listKichThuoc);
req.getRequestDispatcher("/chi-tiet.jsp").forward(req, resp);
```

#### Bước 6: JSP `chi-tiet.jsp` render

**Render ảnh sản phẩm (custom tag `safeImage`):**

```jsp
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<img src="<my:safeImage value='${product.image}' width='600' height='600'/>" />
```

`safeImage` xử lý 3 trường hợp:
- URL tuyệt đối (`http://...`): dùng luôn.
- Đường dẫn tương đối: kiểm tra file có tồn tại qua `application.getRealPath()`.
- Trống hoặc không tồn tại: trả về ảnh placeholder.

**Dropdown biến thể (JSTL):**

```jsp
<c:forEach var="v" items="${variants}">
    <c:set var="colorName" value="" />
    <c:set var="sizeName"  value="" />
    <c:forEach var="c" items="${listMauSac}">
        <c:if test="${c.id == v.colorId}"><c:set var="colorName" value="${c.name}" /></c:if>
    </c:forEach>
    <c:forEach var="s" items="${listKichThuoc}">
        <c:if test="${s.id == v.sizeId}"><c:set var="sizeName" value="${s.name}" /></c:if>
    </c:forEach>
    <option value="${v.id}"
            data-price="${v.price != null ? v.price : product.basePrice}"
            data-quantity="${v.quantity}">
        Màu ${colorName} - Size ${sizeName} (Kho: ${v.quantity})
    </option>
</c:forEach>
```

Mỗi `<option>` gắn `data-price` và `data-quantity` để JavaScript phía client xử lý.

**JavaScript cập nhật giá khi đổi dropdown:**

```javascript
function updatePrice() {
    var sel = document.getElementById('variantSelect');
    var opt = sel.options[sel.selectedIndex];
    var price    = opt.getAttribute('data-price');
    var quantity = opt.getAttribute('data-quantity');
    document.getElementById('priceDisplay').innerText = formatVND(price);
    document.getElementById('priceInput').value       = price;
    document.getElementById('stockDisplay').innerText = quantity;
}
```

### 2.4. Điểm cần nhấn mạnh khi bảo vệ

- **Tại sao lấy cả danh sách màu và size riêng?** Để map từ `colorId`, `sizeId` (số) trong `san_pham_chi_tiet` sang tên hiển thị. Không JOIN để tránh trùng dữ liệu và dễ xử lý phía view.
- **Tại sao cần `data-price` và `data-quantity` trên option?** Để JavaScript đổi giá/hiển thị tồn kho theo biến thể được chọn, không cần gọi lại server.
- **Tại sao dùng custom tag `safeImage`?** Tránh ảnh hỏng/thiếu làm giao diện xấu, tự động fallback sang ảnh placeholder.
- **Tại sao kiểm tra `id` kỹ (null, NumberFormatException)?** Phòng trường hợp người dùng nhập URL sai (`/chi-tiet?id=abc`) hoặc cố tình truy cập không hợp lệ.
- **Biến thể có thể null `price`?** Có - khi đó dùng giá cơ bản của sản phẩm (`product.basePrice`). Logic này được xử lý ở cả JSP lẫn backend.

### 2.5. Câu hỏi bảo vệ thường gặp

**"Tại sao không JOIN bảng màu/size?"**  
Để tránh trùng dòng (nếu 1 biến thể có nhiều bản ghi) và tách logic map ID → tên sang view, dễ đọc hơn.

**"Nếu sản phẩm không có biến thể nào?"**  
Biến thể rỗng → dropdown chỉ hiển thị option mặc định hoặc bị ẩn. Người dùng không thể thêm vào giỏ.

---

## Chức năng 3 - Đặt hàng / Thanh toán ⭐⭐⭐⭐⭐

**Đây là chức năng quan trọng nhất**, dùng **JDBC transaction** để đảm bảo toàn vẹn dữ liệu.

### 3.1. UI người dùng thấy

- Từ giỏ hàng, bấm nút "THANH TOÁN" → chuyển sang trang thanh toán.
- Trang thanh toán gồm 2 phần:
  - **Form thông tin nhận hàng**: Họ tên, SĐT, Địa chỉ, Ghi chú.
  - **Tóm tắt đơn hàng**: danh sách sản phẩm + tổng tiền.
- Form có sẵn họ tên, SĐT, địa chỉ nếu đã đăng nhập (lấy từ `users`).
- 2 radio: **COD** (mặc định) và **Chuyển khoản** (`BANK_TRANSFER`).
- Nút "ĐẶT HÀNG".

### 3.2. URL

```
POST /doanquanaoquybuu/thanh-toan
```

Body gửi:
```
receiverName=Nguyễn Văn A
receiverPhone=0912345678
receiverAddress=Hà Nội
note=Giao giờ hành chính
paymentMethod=COD
```

### 3.3. Luồng xử lý

#### Bước 1: Filter chain
Giống các chức năng khác.

#### Bước 2: `ThanhToanServlet.doPost()`

Servlet lấy các tham số:

```java
String receiverName    = req.getParameter("receiverName");
String receiverPhone   = req.getParameter("receiverPhone");
String receiverAddress = req.getParameter("receiverAddress");
String note            = req.getParameter("note");
String paymentMethod   = req.getParameter("paymentMethod");
```

Lấy giỏ hàng từ session:

```java
List<CartItem> cartItems = CartService.getCart(session);
if (cartItems.isEmpty()) {
    resp.sendRedirect(req.getContextPath() + "/gio-hang");
    return;
}
```

Lấy user đang đăng nhập:

```java
User user = (User) session.getAttribute(Constants.SESSION_USER);
if (user == null) {
    resp.sendRedirect(req.getContextPath() + "/login");
    return;
}
```

Gọi `CheckoutService.checkout()`:

```java
CheckoutService.Result result = checkoutService.checkout(
    user, cartItems, receiverName, receiverPhone,
    receiverAddress, note, paymentMethod);
```

#### Bước 3: `CheckoutService.checkout()`

Validate đầu vào:

```java
public Result checkout(User user, List<CartItem> cartItems,
                       String receiverName, String receiverPhone,
                       String receiverAddress, String note,
                       String paymentMethod) {
    if (cartItems == null || cartItems.isEmpty())
        return Result.fail("Giỏ hàng trống, không thể thanh toán.");
    if (receiverName == null || receiverName.isBlank()
        || receiverPhone == null || receiverPhone.isBlank()
        || receiverAddress == null || receiverAddress.isBlank()
        || paymentMethod == null || paymentMethod.isBlank())
        return Result.fail("Vui lòng điền đầy đủ thông tin giao hàng.");

    // Tính tổng tiền
    BigDecimal totalAmount = calcTotal(cartItems);

    // Tạo đối tượng HoaDon
    HoaDon order = new HoaDon(
        user.getId(),
        receiverName, receiverPhone.trim(), receiverAddress.trim(),
        note, totalAmount, paymentMethod
    );

    // Gọi DAO để INSERT và trừ tồn kho (TRANSACTION)
    int invoiceId = hoaDonDAO.checkoutTransaction(order, cartItems);

    if (invoiceId == -2) return Result.fail("Có sản phẩm trong giỏ đã hết hàng hoặc không đủ số lượng. Vui lòng kiểm tra lại giỏ hàng.");
    if (invoiceId <= 0)  return Result.fail("Có lỗi xảy ra trong quá trình đặt hàng, vui lòng thử lại.");
    return Result.ok(invoiceId);
}
```

**Tính tổng tiền:**

```java
private BigDecimal calcTotal(List<CartItem> cartItems) {
    BigDecimal sum = BigDecimal.ZERO;
    for (CartItem item : cartItems) {
        sum = sum.add(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
    }
    return sum;
}
```

#### Bước 4: `HoaDonDAO.checkoutTransaction()` - TRÁI TIM CỦA CHỨC NĂNG

Đây là phần dùng **JDBC transaction** - phải giải thích rõ ràng khi bảo vệ.

```java
public int checkoutTransaction(HoaDon order, List<CartItem> cartItems) {
    try (Connection con = getConnection()) {
        con.setAutoCommit(false);   // BẮT ĐẦU TRANSACTION
        try {
            // === Bước 1: INSERT hóa đơn, lấy invoiceId tự sinh ===
            String insertHoaDonSql = "INSERT INTO hoa_don (user_id, receiver_name, "
                + "receiver_phone, receiver_address, note, total_amount, "
                + "payment_method, order_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";
            PreparedStatement psHoaDon = con.prepareStatement(
                insertHoaDonSql, Statement.RETURN_GENERATED_KEYS);
            psHoaDon.setInt(1, order.getUserId());
            psHoaDon.setString(2, order.getReceiverName());
            psHoaDon.setString(3, order.getReceiverPhone());
            psHoaDon.setString(4, order.getReceiverAddress());
            psHoaDon.setString(5, order.getNote());
            psHoaDon.setBigDecimal(6, order.getTotalAmount());
            psHoaDon.setString(7, order.getPaymentMethod());
            psHoaDon.executeUpdate();

            int invoiceId = -1;
            ResultSet rs = psHoaDon.getGeneratedKeys();
            if (rs.next()) invoiceId = rs.getInt(1);

            // === Bước 2 + 3: INSERT chi tiết đơn + UPDATE tồn kho (BATCH) ===
            String insertChiTietSql = "INSERT INTO hoa_don_chi_tiet "
                + "(invoice_id, variant_id, product_name, color_name, size_name, "
                + "product_image, price_at_purchase, quantity, line_total) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psChiTiet = con.prepareStatement(insertChiTietSql);

            String updateStockSql = "UPDATE san_pham_chi_tiet "
                + "SET quantity = quantity - ? "
                + "WHERE id = ? AND quantity >= ?";
            PreparedStatement psStock = con.prepareStatement(updateStockSql);

            for (CartItem item : cartItems) {
                psChiTiet.setInt(1, invoiceId);
                psChiTiet.setInt(2, item.getVariantId());
                psChiTiet.setString(3, item.getProductName());
                psChiTiet.setString(4, item.getColorName());
                psChiTiet.setString(5, item.getSizeName());
                psChiTiet.setString(6, item.getProductImage());
                psChiTiet.setBigDecimal(7, item.getPrice());
                psChiTiet.setInt(8, item.getQuantity());
                psChiTiet.setBigDecimal(9, item.getTotal());
                psChiTiet.addBatch();

                psStock.setInt(1, item.getQuantity());
                psStock.setInt(2, item.getVariantId());
                psStock.setInt(3, item.getQuantity());
                psStock.addBatch();
            }

            psChiTiet.executeBatch();
            int[] stockResults = psStock.executeBatch();

            // === Kiểm tra: nếu bất kỳ UPDATE kho nào thất bại → ROLLBACK ===
            for (int res : stockResults) {
                if (res == 0) {
                    con.rollback();   // Hết hàng → rollback toàn bộ
                    return -2;
                }
            }

            con.commit();  // THÀNH CÔNG - commit toàn bộ
            return invoiceId;

        } catch (SQLException ex) {
            con.rollback();          // LỖI → rollback
            ex.printStackTrace();
            return -1;
        } finally {
            con.setAutoCommit(true);  // Khôi phục auto-commit
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
        return -1;
    }
}
```

#### Bước 5: Servlet xử lý kết quả

```java
if (result.success) {
    // Xóa giỏ hàng session
    CartService.clearCart(session);
    
    // Đặt flash message
    session.setAttribute("flashSuccess", "Đặt hàng thành công! Mã đơn #" + result.invoiceId);
    
    // Redirect sang lịch sử mua
    resp.sendRedirect(req.getContextPath() + "/lich-su-mua-hang?orderId=" + result.invoiceId);
} else {
    req.setAttribute("errorMessage", result.message);
    req.getRequestDispatcher("/thanh-toan.jsp").forward(req, resp);
}
```

### 3.4. Sơ đồ trình tự (để giải thích cho thầy)

```
User → ThanhToanServlet → CheckoutService → HoaDonDAO → Database
                                │
                                ├─ INSERT hoa_don (lấy invoiceId)
                                │
                                ├─ Batch INSERT hoa_don_chi_tiet (snapshot data)
                                │
                                ├─ Batch UPDATE san_pham_chi_tiet SET quantity = quantity - ?
                                │   WHERE id = ? AND quantity >= ?
                                │
                                ├─ Kiểm tra stockResults
                                │   ├─ Tất cả > 0 → COMMIT → trả về invoiceId
                                │   └─ Có 0      → ROLLBACK → trả về -2
                                │
                                └─ Exception → ROLLBACK → trả về -1
```

### 3.5. Điểm cần nhấn mạnh khi bảo vệ

#### 1. Tại sao cần Transaction?

Đảm bảo **3 bước (INSERT hóa đơn + INSERT chi tiết + UPDATE tồn kho)** cùng thành công hoặc cùng thất bại. Nếu không có transaction:
- INSERT hóa đơn thành công, INSERT chi tiết lỗi → đơn "ma" không có chi tiết.
- INSERT chi tiết thành công, UPDATE kho lỗi → khách mua hàng nhưng tồn kho không giảm.

#### 2. Tại sao dùng Batch?

Giảm số lần round-trip giữa Java và SQL Server. Thay vì INSERT từng chi tiết (N lần), gộp thành 1 batch INSERT.

#### 3. Tại sao UPDATE có điều kiện `WHERE id = ? AND quantity >= ?`?

Đây là kỹ thuật **atomic check-and-update** ở tầng SQL, tránh **race condition**:
- Nếu 2 người cùng đặt hàng 1 sản phẩm chỉ còn 1 cái.
- Không có điều kiện `quantity >= ?` → cả 2 cùng trừ → tồn kho âm.
- Có điều kiện → ai đặt sau thấy `quantity < ?` → UPDATE không ảnh hưởng dòng nào → `executeUpdate()` trả về `0`.

#### 4. Tại sao snapshot dữ liệu vào `hoa_don_chi_tiet`?

Lưu `product_name`, `color_name`, `size_name`, `price_at_purchase` tại thời điểm mua. Nếu sau này:
- Sản phẩm đổi tên.
- Đổi giá.
- Xóa màu/size.

→ Lịch sử đơn vẫn hiển thị đúng thông tin lúc khách đã mua.

#### 5. Vì sao trả về các giá trị `-1`, `-2`, `invoiceId`?

- `-1`: lỗi SQL chung (exception).
- `-2`: tồn kho không đủ.
- `> 0`: thành công, đồng thời là `invoiceId` tự sinh.

Cho phép phân biệt 2 loại lỗi và hiển thị thông báo khác nhau cho người dùng.

### 3.6. Câu hỏi bảo vệ thường gặp

**"Nếu tồn kho không đủ thì sao?"**  
UPDATE trả về 0 → rollback toàn bộ → trả về `-2` → servlet hiển thị "Có sản phẩm đã hết hàng".

**"Nếu INSERT hóa đơn lỗi thì sao?"**  
Exception → rollback → trả về `-1` → servlet hiển thị "Có lỗi xảy ra".

**"Tại sao không dùng JPA/Hibernate?"**  
Dự án dùng JDBC thuần để kiểm soát transaction tốt hơn và hiểu rõ luồng SQL.

**"Nếu mất kết nối giữa INSERT hóa đơn và INSERT chi tiết?"**  
Connection bị đóng → exception ở try block → rollback → dữ liệu không bị mất một nửa.

---

## Chức năng 4 - Lịch sử mua hàng

### 4.1. UI người dùng thấy

- Click "Lịch Sử Mua" trên header (chỉ hiển thị khi đã đăng nhập).
- Mỗi đơn hiển thị thành **card** gồm:
  - Mã đơn (ví dụ: `#15`).
  - Ngày đặt.
  - **Trạng thái** (badge màu): PENDING (vàng), CONFIRMED (xanh dương), SHIPPING (xanh cyan), FINISH (xanh lá), CANCELLED (đỏ).
  - Người nhận, SĐT, địa chỉ.
  - Danh sách sản phẩm (ảnh nhỏ, tên, màu, size, số lượng, giá).
  - Tổng tiền.
  - Phương thức thanh toán (COD / Chuyển khoản).

### 4.2. URL

```
GET /doanquanaoquybuu/lich-su-mua-hang
```

### 4.3. Luồng xử lý

#### Bước 1: Filter chain
Giống các chức năng khác.

#### Bước 2: `LichSuMuaHangServlet.doGet()`

Kiểm tra đăng nhập:

```java
User user = (User) session.getAttribute(Constants.SESSION_USER);
if (user == null) {
    session.setAttribute(Constants.ATTR_ERROR, "Vui lòng đăng nhập để xem lịch sử mua hàng.");
    resp.sendRedirect(req.getContextPath() + "/login");
    return;
}
```

**Lý do kiểm tra:** Lịch sử mua là dữ liệu riêng tư của từng user, không cho phép xem khi chưa đăng nhập.

#### Bước 3: Gọi `CheckoutService.getOrderHistory()`

```java
List<HoaDon> orders = checkoutService.getOrderHistory(user.getId());
```

Trong `CheckoutService`:

```java
public List<HoaDon> getOrderHistory(int userId) {
    List<HoaDon> orders = hoaDonDAO.getByUserId(userId);
    for (HoaDon order : orders) {
        order.setItems(hoaDonDAO.getChiTietByInvoiceId(order.getId()));
    }
    return orders;
}
```

#### Bước 4: DAO thực thi

**Lấy danh sách hóa đơn:**

```sql
SELECT * FROM hoa_don
WHERE user_id = ?
ORDER BY created_at DESC
```

Trong `HoaDonDAO`:

```java
public List<HoaDon> getByUserId(int userId) {
    String sql = "SELECT * FROM hoa_don WHERE user_id = ? ORDER BY created_at DESC";
    // ps.setInt(1, userId);
    // ... map từng row thành HoaDon
    return list;
}
```

**Với mỗi đơn, lấy chi tiết:**

```sql
SELECT * FROM hoa_don_chi_tiet WHERE invoice_id = ?
```

Trong `HoaDonDAO`:

```java
public List<HoaDonChiTiet> getChiTietByInvoiceId(int invoiceId) {
    String sql = "SELECT * FROM hoa_don_chi_tiet WHERE invoice_id = ?";
    // ps.setInt(1, invoiceId);
    // ... map từng row thành HoaDonChiTiet
    return list;
}
```

#### Bước 5: Servlet đặt attribute và forward

```java
req.setAttribute("orders", orders);
req.getRequestDispatcher("/lich-su-mua-hang.jsp").forward(req, resp);
```

#### Bước 6: JSP `lich-su-mua-hang.jsp` render

**Render trạng thái (JSTL `<c:choose>`):**

```jsp
<c:forEach var="order" items="${orders}">
    <div class="order-card">
        <div class="order-header">
            <h3>Đơn hàng #${order.id}</h3>
            <span class="order-date">${order.createdAt}</span>
            <c:choose>
                <c:when test="${order.orderStatus == 'PENDING'}">
                    <span class="order-status status-pending">Chờ xác nhận</span>
                </c:when>
                <c:when test="${order.orderStatus == 'CONFIRMED'}">
                    <span class="order-status status-confirmed">Đã xác nhận</span>
                </c:when>
                <c:when test="${order.orderStatus == 'SHIPPING'}">
                    <span class="order-status status-shipping">Đang giao</span>
                </c:when>
                <c:when test="${order.orderStatus == 'FINISH'}">
                    <span class="order-status status-finish">Hoàn thành</span>
                </c:when>
                <c:when test="${order.orderStatus == 'CANCELLED'}">
                    <span class="order-status status-cancelled">Đã hủy</span>
                </c:when>
            </c:choose>
        </div>
        
        <div class="order-info">
            <p><strong>Người nhận:</strong> ${order.receiverName} - ${order.receiverPhone}</p>
            <p><strong>Địa chỉ:</strong> ${order.receiverAddress}</p>
            <c:if test="${not empty order.note}">
                <p><strong>Ghi chú:</strong> ${order.note}</p>
            </c:if>
            <p><strong>Thanh toán:</strong> ${order.paymentMethod == 'COD' ? 'COD' : 'Chuyển khoản'}</p>
        </div>
        
        <table class="order-items">
            <c:forEach var="item" items="${order.items}">
                <tr>
                    <td><img src="<my:safeImage value='${item.productImage}' width='60' height='60'/>" /></td>
                    <td>${item.productName} - ${item.colorName} - ${item.sizeName}</td>
                    <td>${item.quantity} x ${item.priceAtPurchase}đ</td>
                    <td>${item.lineTotal}đ</td>
                </tr>
            </c:forEach>
        </table>
        
        <div class="order-total">
            <strong>Tổng tiền: ${order.totalAmount}đ</strong>
        </div>
    </div>
</c:forEach>
```

### 4.4. Điểm cần nhấn mạnh khi bảo vệ

- **Phải đăng nhập mới xem được**: vì lịch sử là dữ liệu riêng tư.
- **Gọi 2 lần DAO (1 cho hóa đơn, 1 cho chi tiết)**: không JOIN để tránh trùng dòng và dễ xử lý phía view. Mỗi hóa đơn có thể có nhiều chi tiết → tách 2 query.
- **ORDER BY created_at DESC**: hiển thị đơn mới nhất trước.
- **Snapshot dữ liệu**: `product_name`, `color_name`, `size_name`, `price_at_purchase` trong `hoa_don_chi_tiet` đảm bảo lịch sử không phụ thuộc sản phẩm hiện tại.
- **Render badge trạng thái**: dùng `<c:choose>` để chuyển mã trạng thái (PENDING/CONFIRMED/...) sang text + class CSS màu tương ứng.

### 4.5. Câu hỏi bảo vệ thường gặp

**"Tại sao không JOIN để lấy hóa đơn + chi tiết trong 1 query?"**  
Để tránh trùng dòng (1 hóa đơn có N chi tiết → JOIN trả về N dòng, các cột hóa đơn bị lặp). Tách 2 query giúp code rõ ràng và dễ xử lý trong Java.

**"Nếu user có 1000 đơn hàng thì sao?"**  
Hiện tại chưa phân trang → load hết. Có thể cải tiến bằng phân trang tương tự đơn hàng admin.

**"Có thể hủy đơn không?"**  
Hiện tại chỉ admin mới đổi trạng thái đơn (ở `/admin/orders`). User không có nút hủy.

---

## Tóm tắt 4 chức năng

| # | Chức năng | Servlet | Điểm quan trọng nhất |
|---|-----------|---------|----------------------|
| 1 | Tìm kiếm | `TrangChuServlet` (nhánh `keyword`) | SQL `LIKE` với wildcard ở 2 phía |
| 2 | Chi tiết sản phẩm | `ChiTietServlet` | Lấy biến thể + màu/size, custom tag `safeImage` |
| 3 | Đặt hàng | `ThanhToanServlet` | **JDBC transaction** với batch insert/update |
| 4 | Lịch sử mua | `LichSuMuaHangServlet` | Gọi 2 DAO, render badge trạng thái |

---

## 10 câu hỏi bảo vệ thường gặp cho phần của tôi

### 1. "Tại sao tìm kiếm dùng `LIKE` mà không dùng Full-Text Search?"

Vì sản phẩm có mô tả ngắn và cỡ dữ liệu nhỏ, `LIKE` đủ dùng. Full-Text cần cấu hình index riêng và câu truy vấn phức tạp hơn.

### 2. "Tại sao chi tiết sản phẩm lấy cả màu + size riêng mà không JOIN?"

Để tránh trùng dòng và tách logic map ID → tên sang view. Nếu 1 biến thể có nhiều bản ghi, JOIN sẽ trả về nhiều dòng trùng.

### 3. "Tại sao đặt hàng phải dùng Transaction?"

Đảm bảo 3 bước (INSERT hóa đơn + INSERT chi tiết + UPDATE tồn kho) cùng thành công hoặc cùng thất bại. Không có transaction → dữ liệu có thể "mất một nửa".

### 4. "Tại sao UPDATE kho có điều kiện `WHERE quantity >= ?`?"

Tránh race condition: nếu 2 người cùng đặt 1 sản phẩm chỉ còn 1 cái, không có điều kiện này → cả 2 cùng trừ → tồn kho âm.

### 5. "Tại sao dùng Batch?"

Giảm số lần round-trip giữa Java và SQL Server. Gộp nhiều INSERT/UPDATE thành 1 batch.

### 6. "Tại sao snapshot dữ liệu vào `hoa_don_chi_tiet`?"

Để lịch sử đơn không phụ thuộc sản phẩm hiện tại. Nếu sản phẩm đổi tên/giá/xóa, lịch sử vẫn hiển thị đúng.

### 7. "Nếu tồn kho không đủ thì sao?"

UPDATE trả về 0 → rollback toàn bộ → trả về `-2` → servlet hiển thị "Có sản phẩm đã hết hàng".

### 8. "Lịch sử mua có cần đăng nhập không?"

Có, vì lịch sử là dữ liệu riêng tư. Nếu chưa đăng nhập → redirect `/login`.

### 9. "Tại sao lịch sử gọi 2 query thay vì JOIN?"

Mỗi hóa đơn có nhiều chi tiết → JOIN trả về nhiều dòng trùng (các cột hóa đơn bị lặp). Tách 2 query giúp code rõ ràng.

### 10. "Custom tag `safeImage` để làm gì?"

Tránh ảnh hỏng/thiếu làm giao diện xấu. Tự động kiểm tra file tồn tại, fallback sang ảnh placeholder nếu lỗi.

---

## Sơ đồ tổng hợp luồng của tôi

```
[User]
  │
  ├─ Tìm kiếm ──── GET /trang-chu?keyword=...
  │                   └→ TrangChuServlet
  │                       └→ CatalogService
  │                           └→ SanPhamDAO.searchByKeyword()
  │                               └→ SELECT * FROM san_pham WHERE name LIKE ? OR description LIKE ?
  │
  ├─ Chi tiết ──── GET /chi-tiet?id=...
  │                   └→ ChiTietServlet
  │                       ├→ CatalogService.getProductById()
  │                       ├→ VariantService.getByProductId()
  │                       ├→ ColorService.getAll()
  │                       └→ SizeService.getAll()
  │
  ├─ Đặt hàng ──── POST /thanh-toan
  │                   └→ ThanhToanServlet
  │                       └→ CheckoutService.checkout()
  │                           └→ HoaDonDAO.checkoutTransaction() ⭐ TRANSACTION
  │                               ├→ INSERT hoa_don
  │                               ├→ Batch INSERT hoa_don_chi_tiet
  │                               ├→ Batch UPDATE san_pham_chi_tiet (with WHERE quantity >= ?)
  │                               └→ COMMIT hoặc ROLLBACK
  │
  └─ Lịch sử ──── GET /lich-su-mua-hang
                      └→ LichSuMuaHangServlet
                          └→ CheckoutService.getOrderHistory()
                              ├→ HoaDonDAO.getByUserId()
                              └→ HoaDonDAO.getChiTietByInvoiceId() (for each order)
```
