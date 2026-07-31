package controller;

import model.CartItem;
import model.User;
import service.CartService;
import service.CheckoutService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.Constants;

import java.io.IOException;
import java.util.List;

@WebServlet("/thanh-toan")
public class ThanhToanServlet extends HttpServlet {

    private CheckoutService checkoutService = new CheckoutService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (CartService.getCart(session).isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/gio-hang");
            return;
        }
        req.setAttribute("user", session.getAttribute(Constants.SESSION_USER));
        req.setAttribute("cartItems", CartService.getCart(session));
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

        User user = (User) session.getAttribute(Constants.SESSION_USER);
        CheckoutService.Result result = checkoutService.checkout(
                user,
                cartItems,
                req.getParameter("receiverName"),
                req.getParameter("receiverPhone"),
                req.getParameter("receiverAddress"),
                req.getParameter("note"),
                req.getParameter("paymentMethod")
        );

        if (result.success) {
            CartService.clearCart(session);
            req.getSession().setAttribute("flashSuccess", result.message);
            resp.sendRedirect(req.getContextPath() + "/lich-su-mua-hang?orderId=" + result.orderId);
        } else {
            req.setAttribute("error", result.message);
            req.setAttribute("cartItems", cartItems);
            req.setAttribute("cartTotal", CartService.getCartTotal(session));
            req.getRequestDispatcher("/thanh-toan.jsp").forward(req, resp);
        }
    }
}
