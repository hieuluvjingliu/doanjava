package controller.admin;

import dao.UserDAO;
import dao.SanPhamChiTietDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.HoaDon;
import model.SanPham;
import service.OrderService;
import service.ProductService;
import utils.Constants;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminServlet extends HttpServlet {

    private OrderService orderService = new OrderService();
    private ProductService productService = new ProductService();
    private UserDAO userDAO = new UserDAO();
    private SanPhamChiTietDAO spctDAO = new SanPhamChiTietDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int totalUsers = userDAO.getAll().size();
        int totalProducts = productService.getAll().size();

        List<HoaDon> allOrders = orderService.getAllOrders();
        int totalOrders = allOrders.size();
        BigDecimal totalRevenue = orderService.calcTotalRevenue(allOrders);

        List<HoaDon> recentOrders = allOrders.size() > 5
            ? allOrders.subList(0, 5)
            : allOrders;

        Map<Integer, Integer> totalStockMap = new HashMap<>();
        for (SanPham sp : productService.getAll()) {
            totalStockMap.put(sp.getId(), spctDAO.getTotalQuantity(sp.getId()));
        }

        request.setAttribute("pageTitle", "Dashboard");
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("totalStockMap", totalStockMap);
        request.setAttribute(Constants.ATTR_CONTENT_PAGE, "/WEB-INF/views/admin/dashboard/dashboard.jsp");

        request.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp")
                .forward(request, response);
    }
}
