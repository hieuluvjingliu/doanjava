package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.HoaDon;
import model.HoaDonChiTiet;
import service.OrderService;
import utils.Constants;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("detail".equals(action)) {
            handleDetail(req, resp);
            return;
        }
        if ("updateStatus".equals(action)) {
            handleUpdateStatus(req, resp);
            return;
        }

        int page = parsePage(req.getParameter("page"));
        int pageSize = Constants.DEFAULT_PAGE_SIZE;

        List<HoaDon> orders = orderService.getOrdersByPage(page, pageSize);
        int totalOrders = orderService.countAllOrders();
        int totalPages = orderService.calcTotalPages(pageSize);

        req.setAttribute("orders", orders);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("contentPage", "/WEB-INF/views/admin/orders.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int orderId = parseInt(req.getParameter("id"), -1);
        if (orderId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
            return;
        }

        HoaDon order = orderService.getOrderDetail(orderId);
        if (order == null) {
            req.getSession().setAttribute("flashError", "Không tìm thấy đơn hàng #" + orderId);
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
            return;
        }

        List<HoaDonChiTiet> details = orderService.getOrderItems(orderId);
        req.setAttribute("order", order);
        req.setAttribute("details", details);
        req.setAttribute("contentPage", "/WEB-INF/views/admin/order/order-detail.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int orderId = parseInt(req.getParameter("id"), -1);
        String status = req.getParameter("status");

        if (orderId > 0 && orderService.isValidStatus(status)) {
            orderService.updateOrderStatus(orderId, status);
            req.getSession().setAttribute("flashSuccess", "Đã cập nhật trạng thái đơn #" + orderId);
        } else {
            req.getSession().setAttribute("flashError", "Trạng thái không hợp lệ.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/orders");
    }

    private static int parsePage(String s) {
        try { return Math.max(1, Integer.parseInt(s)); } catch (Exception e) { return 1; }
    }

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}
