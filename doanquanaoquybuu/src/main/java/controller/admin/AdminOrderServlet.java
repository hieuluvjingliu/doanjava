package controller.admin;

import dao.HoaDonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.HoaDon;
import model.HoaDonChiTiet;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private HoaDonDAO hoaDonDAO = new HoaDonDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("detail".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("id"));
            HoaDon order = hoaDonDAO.getById(orderId);
            List<HoaDonChiTiet> details = hoaDonDAO.getChiTietByInvoiceId(orderId);
            req.setAttribute("order", order);
            req.setAttribute("details", details);
            req.setAttribute("contentPage", "/WEB-INF/views/admin/order/order-detail.jsp");
            req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
        } else if ("updateStatus".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("id"));
            String status = req.getParameter("status");
            hoaDonDAO.updateStatus(orderId, status);
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
        } else {
            List<HoaDon> orders = hoaDonDAO.getAll();
            req.setAttribute("orders", orders);
            req.setAttribute("contentPage", "/WEB-INF/views/admin/orders.jsp");
            req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
        }
    }
}
