package controller;

import model.User;
import service.AuthService;
import service.CartService;
import utils.Constants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("logout".equals(req.getParameter("action"))) {
            HttpSession s = req.getSession(false);
            if (s != null) s.invalidate();
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User user = authService.login(email, password);
        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute(Constants.SESSION_USER, user);
            CartService.mergeOnLogin(session, user);

            if (Constants.ROLE_ADMIN.equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/trang-chu");
            }
        } else {
            req.setAttribute(Constants.ATTR_ERROR, "Email hoặc mật khẩu không chính xác.");
            req.setAttribute("enteredEmail", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
