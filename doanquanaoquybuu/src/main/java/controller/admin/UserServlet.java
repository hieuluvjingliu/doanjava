package controller.admin;

import model.User;
import service.UserService;
import utils.Constants;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class UserServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<User> list = userService.getAll();
        req.setAttribute("listUser", list);
        req.setAttribute(Constants.ATTR_CONTENT_PAGE, "/WEB-INF/views/admin/user/users.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        // Chỉ hỗ trợ hành động: khóa / mở khóa tài khoản
        if (!"toggleStatus".equals(action)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        int targetId = parseInt(req.getParameter("id"), -1);
        String newStatus = req.getParameter("status");
        if (newStatus == null
                || !(Constants.STATUS_USER_ACTIVE.equals(newStatus) || Constants.STATUS_USER_INACTIVE.equals(newStatus))) {
            setFlash(req, "error", "Trạng thái không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        User currentUser = (User) req.getSession().getAttribute(Constants.SESSION_USER);
        Integer currentAdminId = currentUser != null ? currentUser.getId() : null;

        // Chặn admin tự khóa chính mình
        if (currentAdminId != null && currentAdminId == targetId) {
            setFlash(req, "error", "Không thể tự khóa tài khoản của chính mình.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        // Chặn khóa tài khoản Admin khác (chỉ Customer mới bị khóa được)
        User targetUser = userService.getById(targetId);
        if (targetUser == null) {
            setFlash(req, "error", "Không tìm thấy tài khoản.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }
        if (Constants.ROLE_ADMIN.equals(targetUser.getRole())) {
            setFlash(req, "error", "Không thể khóa tài khoản Admin.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        boolean ok = userService.setStatus(targetId, newStatus, currentAdminId);
        if (ok) {
            String msg = Constants.STATUS_USER_ACTIVE.equals(newStatus)
                    ? "Đã mở khóa tài khoản."
                    : "Đã khóa tài khoản.";
            setFlash(req, "success", msg);
        } else {
            setFlash(req, "error", "Không thể cập nhật trạng thái.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private static void setFlash(HttpServletRequest req, String type, String message) {
        req.getSession().setAttribute("flash" + (type.equals("success") ? "Success" : "Error"), message);
    }
}
