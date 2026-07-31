package service;

import dao.HoaDonDAO;
import model.HoaDon;
import model.HoaDonChiTiet;
import utils.Constants;

import java.math.BigDecimal;
import java.util.List;

/**
 * Service xử lý nghiệp vụ đơn hàng: truy vấn, phân trang, cập nhật trạng thái,
 * tính tổng doanh thu.
 */
public class OrderService {

    private final HoaDonDAO hoaDonDAO = new HoaDonDAO();

    /** @return toàn bộ đơn hàng (sắp xếp mới nhất trước). */
    public List<HoaDon> getAllOrders() {
        return hoaDonDAO.getAll();
    }

    /**
     * Lấy đơn hàng theo phân trang — chuẩn SQL Server ({@code OFFSET … FETCH NEXT}).
     * @param page trang (bắt đầu từ 1)
     * @param pageSize số phần tử mỗi trang
     */
    public List<HoaDon> getOrdersByPage(int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = Constants.DEFAULT_PAGE_SIZE;
        int offset = (page - 1) * pageSize;
        return hoaDonDAO.getByPage(offset, pageSize);
    }

    /** @return tổng số đơn hàng. */
    public int countAllOrders() {
        return hoaDonDAO.countAll();
    }

    /**
     * Tính tổng số trang.
     * @return tổng trang (luôn &ge; 1)
     */
    public int calcTotalPages(int pageSize) {
        int total = countAllOrders();
        if (total <= 0) return 1;
        return (int) Math.ceil((double) total / pageSize);
    }

    /**
     * Lấy chi tiết một đơn hàng.
     * @param orderId id đơn hàng
     * @return đơn hàng hoặc {@code null}
     */
    public HoaDon getOrderDetail(int orderId) {
        if (orderId <= 0) return null;
        return hoaDonDAO.getById(orderId);
    }

    /**
     * Lấy danh sách sản phẩm trong đơn.
     * @return danh sách chi tiết (rỗng nếu không tìm thấy)
     */
    public List<HoaDonChiTiet> getOrderItems(int orderId) {
        if (orderId <= 0) return java.util.Collections.emptyList();
        return hoaDonDAO.getChiTietByInvoiceId(orderId);
    }

    /**
     * Cập nhật trạng thái đơn hàng.
     * @return {@code true} nếu cập nhật thành công
     */
    public boolean updateOrderStatus(int orderId, String status) {
        if (orderId <= 0 || status == null) return false;
        return hoaDonDAO.updateStatus(orderId, status);
    }

    /**
     * Kiểm tra {@code status} có thuộc các giá trị trạng thái hợp lệ được khai báo
     * trong {@link Constants} hay không.
     */
    public boolean isValidStatus(String status) {
        if (status == null) return false;
        return status.equals(Constants.ORDER_PENDING)
            || status.equals(Constants.ORDER_CONFIRMED)
            || status.equals(Constants.ORDER_SHIPPING)
            || status.equals(Constants.ORDER_FINISH)
            || status.equals(Constants.ORDER_CANCELLED);
    }

    /**
     * Tính tổng doanh thu từ các đơn hàng có trạng thái {@code FINISH}.
     * @return tổng doanh thu (luôn &ge; 0)
     */
    public BigDecimal calcTotalRevenue(List<HoaDon> orders) {
        BigDecimal sum = BigDecimal.ZERO;
        if (orders == null) return sum;
        for (HoaDon o : orders) {
            if (Constants.ORDER_FINISH.equals(o.getOrderStatus()) && o.getTotalAmount() != null) {
                sum = sum.add(o.getTotalAmount());
            }
        }
        return sum;
    }
}
