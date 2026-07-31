package controller;

import dao.HoaDonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import model.HoaDon;
import model.HoaDonChiTiet;
import model.User;
import service.CartService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/thanh-toan")
public class ThanhToanServlet extends HttpServlet {

    private HoaDonDAO hoaDonDAO = new HoaDonDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("LOGIN_USER");
        List<CartItem> cartItems = CartService.getCart(session);

        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/gio-hang");
            return;
        }

        req.setAttribute("user", user);
        req.setAttribute("cartItems", cartItems);
        req.setAttribute("cartTotal", CartService.getCartTotal(session));
        req.getRequestDispatcher("/thanh-toan.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        List<CartItem> cartItems = CartService.getCart(session);

        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/gio-hang");
            return;
        }

        String receiverName = req.getParameter("receiverName");
        String receiverPhone = req.getParameter("receiverPhone");
        String receiverAddress = req.getParameter("receiverAddress");
        String note = req.getParameter("note");
        String paymentMethod = req.getParameter("paymentMethod");

        if (receiverName == null || receiverPhone == null || receiverAddress == null || paymentMethod == null) {
            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
            req.setAttribute("cartItems", cartItems);
            req.setAttribute("cartTotal", CartService.getCartTotal(session));
            req.getRequestDispatcher("/thanh-toan.jsp").forward(req, resp);
            return;
        }

        User user = (User) session.getAttribute("LOGIN_USER");
        int userId = (user != null) ? user.getId() : 0;
        BigDecimal totalAmount = CartService.getCartTotal(session);

        HoaDon hoaDon = new HoaDon(userId, receiverName, receiverPhone, receiverAddress, note, totalAmount, paymentMethod);
        int invoiceId = hoaDonDAO.createHoaDon(hoaDon);

        if (invoiceId > 0) {
            for (CartItem item : cartItems) {
                HoaDonChiTiet chiTiet = new HoaDonChiTiet(
                    invoiceId, 
                    item.getProductId(),
                    item.getProductName(),
                    "", "",
                    item.getProductImage(),
                    item.getPrice(),
                    item.getQuantity()
                );
                hoaDonDAO.createHoaDonChiTiet(chiTiet);
                hoaDonDAO.updateStock(item.getProductId(), item.getQuantity());
            }
            
            CartService.clearCart(session);
            resp.sendRedirect(req.getContextPath() + "/thanh-toan?success=true&orderId=" + invoiceId);
        } else {
            req.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại");
            req.setAttribute("cartItems", cartItems);
            req.setAttribute("cartTotal", CartService.getCartTotal(session));
            req.getRequestDispatcher("/thanh-toan.jsp").forward(req, resp);
        }
    }
}
