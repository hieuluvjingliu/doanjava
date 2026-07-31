package controller.admin;

import dao.HoaDonDAO;
import dao.SanPhamDAO;
import dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.HoaDon;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminServlet extends HttpServlet {

    private HoaDonDAO hoaDonDAO = new HoaDonDAO();
    private SanPhamDAO sanPhamDAO = new SanPhamDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int totalUsers = userDAO.getAll().size();
        int totalProducts = sanPhamDAO.getAll().size();
        List<HoaDon> allOrders = hoaDonDAO.getAll();
        int totalOrders = allOrders.size();
        
        BigDecimal totalRevenue = BigDecimal.ZERO;
        for (HoaDon order : allOrders) {
            if ("FINISH".equals(order.getOrderStatus())) {
                totalRevenue = totalRevenue.add(order.getTotalAmount());
            }
        }
        
        List<HoaDon> recentOrders = allOrders.size() > 5 
            ? allOrders.subList(0, 5) 
            : allOrders;

        request.setAttribute("pageTitle", "Dashboard");
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("contentPage", "/WEB-INF/views/admin/dashboard/dashboard.jsp");

        request.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp")
                .forward(request, response);
    }
}
