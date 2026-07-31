package service;

import dao.HoaDonDAO;
import model.HoaDon;
import model.HoaDonChiTiet;
import utils.Constants;

import java.math.BigDecimal;
import java.util.List;

public class OrderService {

    private final HoaDonDAO hoaDonDAO = new HoaDonDAO();

    public List<HoaDon> getAllOrders() {
        return hoaDonDAO.getAll();
    }

    public List<HoaDon> getOrdersByPage(int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = Constants.DEFAULT_PAGE_SIZE;
        int offset = (page - 1) * pageSize;
        return hoaDonDAO.getByPage(offset, pageSize);
    }

    public int countAllOrders() {
        return hoaDonDAO.countAll();
    }

    public int calcTotalPages(int pageSize) {
        int total = countAllOrders();
        if (total <= 0) return 1;
        return (int) Math.ceil((double) total / pageSize);
    }

    public HoaDon getOrderDetail(int orderId) {
        if (orderId <= 0) return null;
        return hoaDonDAO.getById(orderId);
    }

    public List<HoaDonChiTiet> getOrderItems(int orderId) {
        if (orderId <= 0) return java.util.Collections.emptyList();
        return hoaDonDAO.getChiTietByInvoiceId(orderId);
    }

    public boolean updateOrderStatus(int orderId, String status) {
        if (orderId <= 0 || status == null) return false;
        return hoaDonDAO.updateStatus(orderId, status);
    }

    public boolean isValidStatus(String status) {
        if (status == null) return false;
        return status.equals(Constants.ORDER_PENDING)
            || status.equals(Constants.ORDER_CONFIRMED)
            || status.equals(Constants.ORDER_SHIPPING)
            || status.equals(Constants.ORDER_FINISH)
            || status.equals(Constants.ORDER_CANCELLED);
    }

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
