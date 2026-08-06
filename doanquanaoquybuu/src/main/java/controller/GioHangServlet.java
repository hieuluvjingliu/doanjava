package controller;

import model.CartItem;
import service.CartService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

        try {
            switch (action == null ? "" : action) {
                case "add": {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    int variantId = Integer.parseInt(req.getParameter("variantId"));
                    String productName = req.getParameter("productName");
                    String colorName = req.getParameter("colorName");
                    String sizeName = req.getParameter("sizeName");
                    String productImage = req.getParameter("productImage");
                    BigDecimal price = new BigDecimal(req.getParameter("price"));
                    int quantity = Integer.parseInt(req.getParameter("quantity"));
                    CartService.addToCart(session, new CartItem(productId, variantId, productName, colorName, sizeName, productImage, price, quantity));
                    session.setAttribute("flashSuccess", "Đã thêm sản phẩm vào giỏ.");
                    resp.sendRedirect(req.getContextPath() + "/gio-hang");
                    break;
                }
                case "update": {
                    CartService.updateQuantity(session, Integer.parseInt(req.getParameter("variantId")),
                                                Integer.parseInt(req.getParameter("quantity")));
                    resp.sendRedirect(req.getContextPath() + "/gio-hang");
                    break;
                }
                case "remove": {
                    CartService.removeFromCart(session, Integer.parseInt(req.getParameter("variantId")));
                    resp.sendRedirect(req.getContextPath() + "/gio-hang");
                    break;
                }
                case "clear": {
                    CartService.clearCart(session);
                    session.setAttribute("flashSuccess", "Đã xóa toàn bộ giỏ hàng.");
                    resp.sendRedirect(req.getContextPath() + "/gio-hang");
                    break;
                }
                default:
                    resp.sendRedirect(req.getContextPath() + "/gio-hang");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Dữ liệu đầu vào không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/gio-hang");
        }
    }
}
