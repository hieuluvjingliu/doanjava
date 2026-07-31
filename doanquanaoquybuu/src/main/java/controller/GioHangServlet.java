package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import service.CartService;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/gio-hang")
public class GioHangServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        req.setAttribute("cartItems", CartService.getCart(session));
        req.setAttribute("cartTotal", CartService.getCartTotal(session));
        req.setAttribute("cartCount", CartService.getCartCount(session));
        req.getRequestDispatcher("/gio-hang.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            String productName = req.getParameter("productName");
            String productImage = req.getParameter("productImage");
            BigDecimal price = new BigDecimal(req.getParameter("price"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));

            CartItem item = new CartItem(productId, productName, productImage, price, quantity);
            CartService.addToCart(session, item);

            resp.sendRedirect(req.getContextPath() + "/gio-hang?msg=added");
        } else if ("update".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            CartService.updateQuantity(session, productId, quantity);
            resp.sendRedirect(req.getContextPath() + "/gio-hang");
        } else if ("remove".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            CartService.removeFromCart(session, productId);
            resp.sendRedirect(req.getContextPath() + "/gio-hang");
        } else if ("clear".equals(action)) {
            CartService.clearCart(session);
            resp.sendRedirect(req.getContextPath() + "/gio-hang");
        } else {
            resp.sendRedirect(req.getContextPath() + "/gio-hang");
        }
    }
}
