# Các chức năng hiện có của dự án QUYBUU Store

## 1. Phạm vi tài liệu

Tài liệu này mô tả các chức năng đang được triển khai trong mã nguồn hiện tại của dự án `doanquanaoquybuu`.

Hệ thống là website bán quần áo, đồ Anime/Cosplay được xây dựng bằng Java Servlet, JSP, JSTL và SQL Server theo mô hình MVC có thêm tầng Service.

Hệ thống có ba vai trò người dùng:

- `CUSTOMER`: khách hàng mua sắm.
- `STAFF`: nhân viên vận hành cửa hàng.
- `ADMIN`: quản trị viên có quyền quản lý cao nhất.

## 2. Chức năng dành cho khách truy cập và khách hàng

### 2.1. Trang chủ và danh mục sản phẩm

Đường dẫn chính: `/trang-chu`

Các chức năng đang có:

- Hiển thị danh sách danh mục sản phẩm.
- Hiển thị khu vực danh mục nổi bật, tối đa 4 danh mục trên giao diện trang chủ.
- Hiển thị khu vực sản phẩm nổi bật, hiện tại tối đa 4 sản phẩm.
- Lọc sản phẩm theo danh mục bằng tham số `category`.
- Tìm kiếm sản phẩm bằng từ khóa qua tham số `keyword`.
- Tìm kiếm trên cả tên và mô tả sản phẩm.
- Chuyển từ thẻ sản phẩm sang trang chi tiết sản phẩm.
- Hiển thị giá cơ bản và ảnh sản phẩm.
- Dùng ảnh thay thế từ `placehold.co` nếu ảnh bị trống hoặc tệp ảnh cục bộ không tồn tại.
- Hiển thị trạng thái rỗng hoặc dữ liệu mẫu trên giao diện khi không có dữ liệu sản phẩm/danh mục.

Các tiện ích giao diện đang có:

- Thanh điều hướng cố định khi cuộn trang.
- Menu danh mục dạng thả xuống trên máy tính.
- Menu dạng ngăn kéo trên thiết bị di động.
- Ô tìm kiếm có thể đóng/mở.
- Hiển thị tên người dùng khi đã đăng nhập.
- Hiển thị số lượng sản phẩm trong giỏ hàng trên biểu tượng giỏ hàng.
- Chế độ sáng/tối và ghi nhớ lựa chọn bằng `localStorage`.
- Nút quay lại đầu trang.
- Giao diện responsive cho máy tính, máy tính bảng và điện thoại.

### 2.2. Xem chi tiết sản phẩm

Đường dẫn: `/chi-tiet?id={productId}`

Các chức năng đang có:

- Kiểm tra mã sản phẩm trước khi tải dữ liệu.
- Chuyển về trang chủ nếu mã sản phẩm không hợp lệ hoặc sản phẩm không tồn tại.
- Hiển thị tên, mô tả, ảnh và giá cơ bản của sản phẩm.
- Hiển thị các biến thể của sản phẩm theo màu sắc và kích thước.
- Hiển thị số lượng tồn kho của từng biến thể.
- Cho phép biến thể có giá bán riêng.
- Nếu biến thể không có giá riêng thì sử dụng giá cơ bản của sản phẩm.
- Cho phép chọn biến thể và nhập số lượng trước khi thêm vào giỏ hàng.
- Gửi kèm tên sản phẩm, màu, kích thước, ảnh và giá của biến thể sang giỏ hàng.

### 2.3. Đăng ký tài khoản

Đường dẫn: `/register`

Các chức năng đang có:

- Đăng ký tài khoản khách hàng mới.
- Thu thập họ tên, email, số điện thoại, địa chỉ và mật khẩu.
- Kiểm tra họ tên không được để trống, có từ 2 đến 100 ký tự.
- Kiểm tra định dạng email.
- Kiểm tra số điện thoại di động Việt Nam nếu người dùng có nhập.
- Yêu cầu mật khẩu có ít nhất 6 ký tự.
- Tự động gán vai trò `CUSTOMER`.
- Tự động gán trạng thái `ACTIVE`.
- Hiển thị lỗi nếu dữ liệu không hợp lệ hoặc email có thể đã tồn tại.
- Giữ lại các trường đã nhập khi đăng ký thất bại, ngoại trừ mật khẩu.
- Chuyển sang trang đăng nhập và hiển thị thông báo sau khi đăng ký thành công.
- Có kiểm tra dữ liệu ở cả phía trình duyệt và phía máy chủ.

### 2.4. Đăng nhập và đăng xuất

Đường dẫn đăng nhập: `/login`

Đường dẫn đăng xuất: `/login?action=logout`

Các chức năng đang có:

- Đăng nhập bằng email và mật khẩu.
- Chỉ cho phép tài khoản có trạng thái `ACTIVE` đăng nhập.
- Lưu người dùng đã đăng nhập trong session với khóa `LOGIN_USER`.
- Chuyển `ADMIN` và `STAFF` đến `/admin/dashboard` sau khi đăng nhập.
- Chuyển `CUSTOMER` đến `/trang-chu` sau khi đăng nhập.
- Hiển thị lỗi nếu email hoặc mật khẩu không đúng.
- Giữ lại email đã nhập khi đăng nhập thất bại.
- Hợp nhất giỏ hàng của khách vãng lai với giỏ hàng đã lưu trong cơ sở dữ liệu khi đăng nhập.
- Đăng xuất bằng cách hủy toàn bộ session và chuyển về trang chủ.

### 2.5. Giỏ hàng

Đường dẫn: `/gio-hang`

Giỏ hàng hỗ trợ cả khách vãng lai và người dùng đã đăng nhập:

- Khách vãng lai được lưu giỏ hàng trong session.
- Người dùng đã đăng nhập được đồng bộ giỏ hàng vào các bảng `carts` và `cart_items`.
- Giỏ hàng trong session và giỏ hàng trong cơ sở dữ liệu được hợp nhất khi đăng nhập.
- Nếu cùng một biến thể đã tồn tại trong giỏ thì số lượng được cộng dồn.

Các thao tác đang có:

- Thêm sản phẩm/biến thể vào giỏ hàng.
- Hiển thị ảnh, tên sản phẩm, màu, kích thước, đơn giá và số lượng.
- Tăng số lượng sản phẩm.
- Giảm số lượng sản phẩm.
- Cập nhật số lượng theo biến thể.
- Xóa một sản phẩm khỏi giỏ.
- Xóa toàn bộ giỏ hàng.
- Tính tổng số lượng sản phẩm trong giỏ.
- Tính thành tiền của từng dòng.
- Tính tổng tiền của toàn bộ giỏ hàng.
- Hiển thị trạng thái giỏ hàng trống.
- Tạo flash message sau khi thêm sản phẩm hoặc xóa toàn bộ giỏ hàng.
- Layout phía khách hàng hiện chưa đọc các flash message này, nên thông báo chưa được hiển thị ổn định trên giao diện.
- Chuyển sang trang thanh toán nếu giỏ hàng có sản phẩm.

### 2.6. Thanh toán và đặt hàng

Đường dẫn: `/thanh-toan`

Các chức năng đang có:

- Không cho mở trang thanh toán khi giỏ hàng trống.
- Hiển thị lại toàn bộ sản phẩm và tổng tiền của đơn hàng.
- Tự điền họ tên, số điện thoại và địa chỉ nếu người dùng đã đăng nhập.
- Nhập thông tin người nhận hàng.
- Nhập ghi chú giao hàng tùy chọn.
- Chọn thanh toán khi nhận hàng `COD`.
- Chọn thanh toán bằng chuyển khoản `BANK_TRANSFER`.
- Kiểm tra họ tên, số điện thoại, địa chỉ và phương thức thanh toán không được để trống.
- Tính tổng đơn hàng từ dữ liệu giỏ hàng.
- Tạo hóa đơn trong bảng `hoa_don`.
- Lưu bản chụp thông tin sản phẩm tại thời điểm mua vào `hoa_don_chi_tiet`, bao gồm tên, màu, kích thước, ảnh, đơn giá, số lượng và thành tiền.
- Trừ tồn kho theo từng biến thể.
- Chỉ trừ kho khi số lượng tồn còn đủ.
- Dùng transaction cho toàn bộ quá trình tạo hóa đơn, tạo chi tiết và trừ tồn kho.
- Rollback toàn bộ đơn hàng nếu một biến thể không đủ tồn kho hoặc có lỗi SQL.
- Hiển thị thông báo cụ thể khi sản phẩm hết hàng hoặc không đủ số lượng.
- Xóa giỏ hàng sau khi đặt hàng thành công.
- Chuyển đến lịch sử mua hàng và mang theo mã đơn vừa tạo.

Lưu ý về trạng thái hiện tại:

- Lược đồ SQL yêu cầu `hoa_don.user_id` phải tham chiếu đến một người dùng hợp lệ.
- Servlet thanh toán chưa chặn khách chưa đăng nhập, nhưng khi khách chưa đăng nhập thì mã người dùng được gán bằng `0`; với lược đồ SQL đi kèm, đơn hàng đó sẽ không tạo thành công.
- Vì vậy, theo cấu hình cơ sở dữ liệu hiện tại, người dùng cần đăng nhập để đặt hàng thành công.

### 2.7. Lịch sử mua hàng

Đường dẫn: `/lich-su-mua-hang`

Các chức năng đang có:

- Yêu cầu người dùng đăng nhập.
- Chuyển người chưa đăng nhập về trang đăng nhập.
- Lấy các đơn hàng của đúng người dùng hiện tại.
- Sắp xếp đơn hàng mới nhất trước.
- Hiển thị mã đơn, thời gian đặt, người nhận, số điện thoại, địa chỉ và ghi chú.
- Hiển thị toàn bộ sản phẩm trong từng đơn hàng.
- Hiển thị màu, kích thước, số lượng và thành tiền của từng sản phẩm.
- Hiển thị tổng tiền và phương thức thanh toán.
- Hiển thị trạng thái đơn hàng bằng nhãn tiếng Việt:
  - `PENDING`: Chờ xác nhận.
  - `CONFIRMED`: Đã xác nhận.
  - `SHIPPING`: Đang giao hàng.
  - `FINISH`: Hoàn thành.
  - `CANCELLED`: Đã hủy.
- Hiển thị trạng thái rỗng nếu khách hàng chưa có đơn hàng.

## 3. Chức năng dành cho quản trị viên và nhân viên

### 3.1. Bảo vệ khu vực quản trị

Phạm vi được bảo vệ: `/admin/*`

Các chức năng phân quyền đang có:

- Yêu cầu phải đăng nhập trước khi truy cập trang quản trị.
- Chỉ chấp nhận vai trò `ADMIN` hoặc `STAFF`.
- Người không đủ quyền được chuyển về trang đăng nhập.
- `STAFF` không được truy cập trang quản lý người dùng.
- `STAFF` không được xóa sản phẩm.
- `ADMIN` có thể truy cập toàn bộ các trang quản trị hiện có.

Lưu ý: ngoài hai giới hạn nêu trên, `STAFF` hiện vẫn có thể truy cập các chức năng quản lý đơn hàng, sản phẩm, biến thể, danh mục, kích thước và màu sắc.

### 3.2. Dashboard quản trị

Đường dẫn: `/admin/dashboard`

Các chức năng đang có:

- Hiển thị tổng số người dùng.
- Hiển thị tổng số sản phẩm.
- Hiển thị tổng số đơn hàng.
- Tính và hiển thị doanh thu.
- Doanh thu chỉ cộng các đơn có trạng thái `FINISH`.
- Hiển thị tối đa 5 đơn hàng gần nhất.
- Hiển thị trạng thái và tổng tiền của các đơn gần nhất.
- Có trạng thái rỗng khi chưa có đơn hàng.

### 3.3. Quản lý đơn hàng

Đường dẫn: `/admin/orders`

Các chức năng đang có:

- Hiển thị danh sách toàn bộ đơn hàng.
- Sắp xếp đơn mới nhất trước.
- Phân trang phía máy chủ với 10 đơn hàng mỗi trang.
- Hiển thị tổng số đơn, trang hiện tại và tổng số trang.
- Có nút về trang đầu, trang trước, trang sau và trang cuối.
- Hiển thị thông tin khách hàng, số điện thoại, địa chỉ, tổng tiền, phương thức thanh toán, trạng thái và ngày tạo.
- Rút gọn địa chỉ dài trên danh sách.
- Hiển thị trạng thái rỗng khi chưa có đơn hàng.
- Xem chi tiết một đơn hàng.
- Xem thông tin người nhận và thông tin thanh toán.
- Xem danh sách sản phẩm, giá mua, số lượng và thành tiền trong đơn.
- Cập nhật trạng thái đơn sang một trong các giá trị hợp lệ:
  - `PENDING`.
  - `CONFIRMED`.
  - `SHIPPING`.
  - `FINISH`.
  - `CANCELLED`.
- Hiển thị thông báo thành công hoặc thất bại sau khi cập nhật.

Giới hạn hiện tại:

- Chưa ép buộc thứ tự chuyển trạng thái; quản trị viên có thể chọn trực tiếp bất kỳ trạng thái hợp lệ nào.
- Khi chuyển đơn sang `CANCELLED`, hệ thống hiện chưa hoàn lại tồn kho.

### 3.4. Quản lý sản phẩm

Đường dẫn: `/admin/products`

Các chức năng đang có:

- Hiển thị danh sách sản phẩm.
- Hiển thị ảnh, tên, danh mục, giá cơ bản, tổng tồn kho và trạng thái.
- Tổng tồn kho được tính từ các biến thể đang `ACTIVE`.
- Phân loại tồn kho bằng nhãn:
  - Hết hàng khi tổng tồn bằng `0`.
  - Tồn thấp khi tổng tồn nhỏ hơn `10`.
  - Tồn đủ khi tổng tồn từ `10` trở lên.
- Thêm sản phẩm mới.
- Cập nhật sản phẩm.
- Xóa sản phẩm.
- Chọn danh mục cho sản phẩm.
- Nhập tên, mô tả, giá cơ bản và trạng thái.
- Nhập URL ảnh sản phẩm.
- Tự sinh ảnh `placehold.co` nếu không nhập URL khi tạo mới.
- Giữ ảnh cũ nếu cập nhật mà không nhập URL ảnh mới.
- Mở trang chi tiết sản phẩm phía khách hàng từ trang quản trị.
- Chuyển đến màn hình quản lý biến thể/tồn kho của từng sản phẩm.
- Hiển thị thông báo sau thao tác thêm, sửa hoặc xóa.

Lưu ý:

- Giao diện hiện nhận URL ảnh; chưa có chức năng tải tệp ảnh từ máy người dùng lên máy chủ.
- Danh sách quản trị sản phẩm hiện chưa kết nối phân trang hoặc tìm kiếm, dù tầng Service/DAO đã có phương thức hỗ trợ các thao tác này.
- Việc xóa có thể thất bại nếu sản phẩm đang được tham chiếu bởi biến thể, giỏ hàng hoặc dữ liệu khác trong cơ sở dữ liệu.

### 3.5. Quản lý biến thể và tồn kho

Đường dẫn: `/admin/san-pham-chi-tiet?productId={productId}`

Các chức năng đang có:

- Hiển thị các biến thể của một sản phẩm.
- Mỗi biến thể gồm màu sắc, kích thước, SKU, giá riêng, số lượng tồn, ảnh riêng và trạng thái.
- Thêm biến thể mới.
- Cập nhật biến thể.
- Xóa biến thể.
- Cho phép để trống giá riêng để dùng giá cơ bản của sản phẩm.
- Quản lý trực tiếp số lượng tồn kho.
- Hiển thị nhãn hết hàng khi tồn bằng `0`.
- Hiển thị nhãn tồn thấp khi tồn nhỏ hơn `5`.
- Hiển thị trạng thái hoạt động hoặc ngừng bán.
- Chuyển nhanh sang trang quản lý màu sắc và kích thước.
- Hiển thị trạng thái rỗng khi sản phẩm chưa có biến thể.

Lược đồ SQL bảo đảm:

- SKU là duy nhất.
- Một sản phẩm không được có hai biến thể trùng hoàn toàn màu và kích thước.
- Số lượng tồn không được âm.

### 3.6. Quản lý danh mục

Đường dẫn: `/admin/danh-muc`

Các chức năng đang có:

- Hiển thị danh sách danh mục.
- Hiển thị tên, mô tả, trạng thái và ngày tạo.
- Thêm danh mục.
- Cập nhật danh mục.
- Xóa danh mục.
- Bật hoặc tắt trạng thái bằng `ACTIVE` và `INACTIVE`.
- Yêu cầu tên danh mục không được để trống khi tạo mới.
- Hiển thị thông báo sau thao tác.

Việc xóa danh mục có thể thất bại nếu danh mục đang được sản phẩm tham chiếu.

### 3.7. Quản lý kích thước

Đường dẫn: `/admin/kich-thuoc`

Các chức năng đang có:

- Hiển thị danh sách kích thước theo `sort_order` tăng dần.
- Thêm kích thước.
- Cập nhật kích thước.
- Xóa kích thước.
- Quản lý tên kích thước, thứ tự hiển thị và trạng thái.
- Không cho thêm tên kích thước đang tồn tại ở trạng thái `ACTIVE`.
- Hiển thị trạng thái hoạt động hoặc không hoạt động.
- Hiển thị trạng thái rỗng khi chưa có kích thước.

Việc xóa kích thước có thể thất bại nếu kích thước đang được biến thể sản phẩm tham chiếu.

### 3.8. Quản lý màu sắc

Đường dẫn: `/admin/mau-sac`

Các chức năng đang có:

- Hiển thị danh sách màu sắc.
- Thêm màu sắc.
- Cập nhật màu sắc.
- Xóa màu sắc.
- Quản lý tên và trạng thái màu.
- Hiển thị trạng thái hoạt động hoặc không hoạt động.
- Hiển thị trạng thái rỗng khi chưa có màu sắc.

Việc xóa màu sắc có thể thất bại nếu màu đang được biến thể sản phẩm tham chiếu.

### 3.9. Quản lý người dùng

Đường dẫn: `/admin/users`

Các chức năng đang có ở giao diện hiện tại:

- Hiển thị danh sách người dùng.
- Hiển thị họ tên, email, số điện thoại, vai trò, trạng thái và ngày tạo.
- Phân biệt vai trò `ADMIN`, `STAFF` và `CUSTOMER` bằng nhãn.
- Hiển thị trạng thái tài khoản hoạt động hoặc bị khóa.
- Hiển thị trạng thái rỗng nếu chưa có người dùng.

Các chức năng đã có ở backend nhưng chưa được nối đầy đủ vào giao diện:

- Backend hỗ trợ tạo người dùng mới, nhưng trang hiện chưa có nút hoặc biểu mẫu thêm người dùng.
- Backend và mẫu modal hỗ trợ cập nhật họ tên, số điện thoại, địa chỉ, vai trò và trạng thái.
- Bảng người dùng hiện chưa có nút sửa, nên chức năng cập nhật chưa thể truy cập bằng luồng giao diện thông thường; có thể mở bằng URL có `action=edit&id=...`.
- Có kiểm tra không cho quản trị viên tự giáng vai trò hoặc tự khóa chính tài khoản đang đăng nhập.

Lưu ý không đồng nhất cần xử lý:

- Mã Java và giao diện dùng trạng thái khóa là `INACTIVE`.
- Lược đồ SQL đi kèm lại chỉ cho trạng thái `ACTIVE` hoặc `LOCKED`.
- Vì vậy thao tác cập nhật tài khoản sang `INACTIVE` có thể bị SQL Server từ chối nếu dùng nguyên lược đồ hiện tại.

## 4. Chức năng dùng chung của hệ thống

### 4.1. Xử lý tiếng Việt và UTF-8

- Filter `EncodingFilter` áp dụng UTF-8 cho toàn bộ request.
- Các response HTML được đặt charset UTF-8.
- Tài nguyên tĩnh như CSS, JavaScript, ảnh và font được loại khỏi việc ép kiểu nội dung HTML.

### 4.2. Xử lý lỗi toàn cục

- `GlobalErrorHandlerFilter` bắt các exception chưa được xử lý từ Servlet hoặc JSP.
- Ghi log lỗi bằng `java.util.logging`.
- Hiển thị trang lỗi thân thiện tại `/error.jsp`.
- Trang lỗi hiển thị mã lỗi, loại lỗi, thông báo và đường dẫn gây lỗi khi có dữ liệu.
- Cho phép người dùng quay về trang chủ hoặc quay lại trang trước.

### 4.3. Flash message

- Các thao tác quản trị dùng session để lưu thông báo thành công hoặc thất bại.
- Layout quản trị hiển thị thông báo dạng alert nổi ở góc trên bên phải.
- Thông báo được xóa khỏi session sau khi hiển thị.

### 4.4. Xử lý ảnh an toàn

Custom tag `safeImage` đang được dùng tại các trang sản phẩm, giỏ hàng, thanh toán và đơn hàng:

- Chấp nhận URL ảnh `http` hoặc `https`.
- Kiểm tra tệp ảnh cục bộ có tồn tại hay không.
- Dùng ảnh thay thế nếu giá trị ảnh trống, bằng `null` hoặc tệp không tồn tại.
- Cho phép chỉ định kích thước ảnh thay thế.

### 4.5. Truy cập dữ liệu

- Các DAO dùng `PreparedStatement` để truyền tham số SQL.
- Có lớp `AbstractDAO` dùng chung cho kết nối và ghi log lỗi SQL.
- Kết nối đến Microsoft SQL Server bằng JDBC.
- Có transaction riêng cho lưu giỏ hàng và đặt hàng.
- Có các chỉ mục SQL phục vụ tìm theo danh mục, sản phẩm, đơn hàng và giỏ hàng.

## 5. Các bảng dữ liệu đang phục vụ chức năng

- `users`: tài khoản, vai trò và trạng thái người dùng.
- `danh_muc`: danh mục sản phẩm.
- `mau_sac`: màu sắc của biến thể.
- `kich_thuoc`: kích thước và thứ tự hiển thị.
- `san_pham`: thông tin sản phẩm cha.
- `san_pham_chi_tiet`: biến thể, SKU, giá riêng và tồn kho.
- `carts`: giỏ hàng của người dùng đã đăng nhập.
- `cart_items`: các dòng sản phẩm trong giỏ hàng.
- `hoa_don`: thông tin đơn hàng.
- `hoa_don_chi_tiet`: bản chụp sản phẩm tại thời điểm mua.
- `gio_hang`: bảng cũ được giữ để tương thích nhưng mã nguồn hiện tại không sử dụng.

## 6. Các luồng nghiệp vụ chính

### 6.1. Luồng mua hàng

1. Người dùng mở `/trang-chu`.
2. Người dùng lọc theo danh mục hoặc tìm kiếm sản phẩm.
3. Người dùng mở `/chi-tiet?id=...`.
4. Người dùng chọn màu, kích thước và số lượng.
5. Sản phẩm được thêm vào `/gio-hang`.
6. Người dùng đăng nhập để giỏ hàng được hợp nhất và lưu vào cơ sở dữ liệu.
7. Người dùng mở `/thanh-toan`, nhập thông tin nhận hàng và chọn phương thức thanh toán.
8. Hệ thống tạo hóa đơn, tạo chi tiết và trừ tồn kho trong cùng một transaction.
9. Sau khi thành công, hệ thống xóa giỏ hàng và chuyển đến `/lich-su-mua-hang`.

### 6.2. Luồng xử lý đơn hàng của quản trị viên

1. `ADMIN` hoặc `STAFF` đăng nhập.
2. Hệ thống chuyển đến `/admin/dashboard`.
3. Người vận hành mở `/admin/orders`.
4. Người vận hành xem chi tiết đơn hàng.
5. Người vận hành cập nhật trạng thái đơn.
6. Hệ thống lưu trạng thái mới và hiển thị flash message.
7. Đơn `FINISH` được tính vào doanh thu trên dashboard.

### 6.3. Luồng giỏ hàng khi đăng nhập

1. Khách vãng lai thêm sản phẩm; giỏ được lưu trong session.
2. Người dùng đăng nhập.
3. Hệ thống tải giỏ hàng đã lưu trong cơ sở dữ liệu.
4. Hai giỏ được hợp nhất theo `variantId`.
5. Nếu cùng biến thể tồn tại ở cả hai giỏ, số lượng được cộng lại.
6. Giỏ đã hợp nhất được lưu lại vào `cart_items`.

## 7. Các thành phần mới có giao diện hoặc chưa hoàn chỉnh

Những mục sau xuất hiện trên giao diện nhưng chưa có luồng nghiệp vụ hoàn chỉnh trong backend hiện tại:

- Nút yêu thích trên thẻ sản phẩm chưa lưu danh sách yêu thích.
- Biểu mẫu đăng ký nhận ưu đãi đang gửi đến `#`, chưa có Servlet xử lý.
- Đồng hồ khuyến mãi trên trang chủ đang hiển thị giá trị tĩnh.
- Nội dung giảm giá trên banner chưa được áp dụng vào phép tính giỏ hàng hoặc đơn hàng.
- Các liên kết giới thiệu, liên hệ, tuyển dụng, tin tức và chính sách ở footer đang dùng `#`.
- Một số liên kết mạng xã hội ở footer đang dùng `#` hoặc URL mẫu.
- Chưa có thanh toán trực tuyến với cổng ngân hàng; lựa chọn chuyển khoản mới chỉ được lưu thành phương thức thanh toán của đơn.
- Chưa có quên mật khẩu, đổi mật khẩu hoặc chỉnh sửa hồ sơ cá nhân.
- Khách hàng chưa thể tự hủy đơn hàng.
- Chưa có đánh giá hoặc bình luận sản phẩm.
- Chưa có mã giảm giá/voucher được tính vào đơn hàng.
- Chưa có chức năng tải tệp ảnh sản phẩm lên máy chủ.

## 8. Danh sách đường dẫn chính

### Khu vực khách hàng

- `/trang-chu`: trang chủ, lọc danh mục và tìm kiếm.
- `/chi-tiet?id=...`: chi tiết sản phẩm.
- `/register`: đăng ký.
- `/login`: đăng nhập.
- `/login?action=logout`: đăng xuất.
- `/gio-hang`: giỏ hàng.
- `/thanh-toan`: thanh toán và đặt hàng.
- `/lich-su-mua-hang`: lịch sử đơn hàng của khách.

### Khu vực quản trị

- `/admin/dashboard`: dashboard.
- `/admin/orders`: quản lý đơn hàng.
- `/admin/products`: quản lý sản phẩm.
- `/admin/san-pham-chi-tiet?productId=...`: quản lý biến thể và tồn kho.
- `/admin/danh-muc`: quản lý danh mục.
- `/admin/kich-thuoc`: quản lý kích thước.
- `/admin/mau-sac`: quản lý màu sắc.
- `/admin/users`: quản lý người dùng.
