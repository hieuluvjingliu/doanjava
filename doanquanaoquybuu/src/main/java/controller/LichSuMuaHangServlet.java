package controller;

import model.HoaDon;
import model.User;
import service.CheckoutService;
import utils.Constants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/lich-su-mua-hang")
public class LichSuMuaHangServlet extends HttpServlet {

    private CheckoutService checkoutService = new CheckoutService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);

        if (user == null) {
            session.setAttribute(Constants.ATTR_ERROR, "Vui lòng đăng nhập để xem lịch sử mua hàng.");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<HoaDon> orders = checkoutService.getOrderHistory(user.getId());
        req.setAttribute("orders", orders);
        req.setAttribute("highlightOrderId", req.getParameter("orderId"));
        req.getRequestDispatcher("/lich-su-mua-hang.jsp").forward(req, resp);
    }
}
