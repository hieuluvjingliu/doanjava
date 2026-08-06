package service;

import dao.HoaDonDAO;
import model.CartItem;
import model.HoaDon;
import model.HoaDonChiTiet;
import model.User;

import java.math.BigDecimal;
import java.util.List;

/**
 * Service xử lý luồng đặt hàng (checkout)
 * — kiểm tra đầu vào, tạo hóa đơn, tạo chi tiết, trừ tồn kho, xoá giỏ.
 */
public class CheckoutService {

    private final HoaDonDAO hoaDonDAO = new HoaDonDAO();

    public static class Result {
        public final boolean success;
        public final String message;
        public final int orderId;

        private Result(boolean success, String message, int orderId) {
            this.success = success;
            this.message = message;
            this.orderId = orderId;
        }

        public static Result ok(int orderId) { return new Result(true, "Đặt hàng thành công!", orderId); }
        public static Result fail(String message) { return new Result(false, message, -1); }
    }

    public Result checkout(User user,
                           List<CartItem> cartItems,
                           String receiverName,
                           String receiverPhone,
                           String receiverAddress,
                           String note,
                           String paymentMethod) {
        if (cartItems == null || cartItems.isEmpty()) {
            return Result.fail("Giỏ hàng trống, không thể thanh toán.");
        }
        if (receiverName == null || receiverName.isBlank()
            || receiverPhone == null || receiverPhone.isBlank()
            || receiverAddress == null || receiverAddress.isBlank()
            || paymentMethod == null || paymentMethod.isBlank()) {
            return Result.fail("Vui lòng điền đầy đủ thông tin giao hàng.");
        }

        int userId = user != null ? user.getId() : 0;
        BigDecimal totalAmount = calcTotal(cartItems);

        HoaDon order = new HoaDon(userId, receiverName, receiverPhone.trim(),
                                  receiverAddress.trim(), note, totalAmount, paymentMethod);
                                  
        int invoiceId = hoaDonDAO.checkoutTransaction(order, cartItems);
        
        if (invoiceId == -2) {
            return Result.fail("Có sản phẩm trong giỏ đã hết hàng hoặc không đủ số lượng.");
        } else if (invoiceId <= 0) {
            return Result.fail("Có lỗi xảy ra trong quá trình đặt hàng, vui lòng thử lại.");
        }

        return Result.ok(invoiceId);
    }

    public List<HoaDon> getOrderHistory(int userId) {
        if (userId <= 0) return java.util.Collections.emptyList();
        List<HoaDon> orders = hoaDonDAO.getByUserId(userId);
        for (HoaDon order : orders) {
            order.setItems(hoaDonDAO.getChiTietByInvoiceId(order.getId()));
        }
        return orders;
    }

    private static BigDecimal calcTotal(List<CartItem> items) {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem it : items) {
            if (it.getPrice() != null) {
                total = total.add(it.getPrice().multiply(BigDecimal.valueOf(it.getQuantity())));
            }
        }
        return total;
    }
}
