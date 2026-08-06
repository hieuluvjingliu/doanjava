package controller.admin;

import model.User;
import utils.Constants;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute(Constants.SESSION_USER);
        if (user != null && (Constants.ROLE_ADMIN.equals(user.getRole()) || Constants.ROLE_STAFF.equals(user.getRole()))) {
            
            boolean isStaff = Constants.ROLE_STAFF.equals(user.getRole());
            String uri = req.getRequestURI();
            String action = req.getParameter("action");

            // Chặn STAFF vào trang quản lý tài khoản
            if (isStaff && uri.contains("/admin/users")) {
                session.setAttribute(Constants.ATTR_ERROR, "Nhân viên không có quyền quản lý tài khoản.");
                res.sendRedirect(req.getContextPath() + "/admin/dashboard");
                return;
            }

            // Chặn STAFF xóa sản phẩm
            if (isStaff && uri.contains("/admin/products") && "delete".equals(action)) {
                session.setAttribute(Constants.ATTR_ERROR, "Nhân viên không có quyền xóa sản phẩm.");
                res.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }

            chain.doFilter(request, response);
        } else {
            if (session != null) {
                session.setAttribute(Constants.ATTR_ERROR, "Vui lòng đăng nhập với tài khoản Admin để truy cập.");
            }
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }
}

