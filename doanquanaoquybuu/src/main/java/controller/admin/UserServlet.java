package controller.admin;

import model.User;
import service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.Constants;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class UserServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        List<User> list = userService.getAll();
        req.setAttribute("listUser", list);
        if ("edit".equals(action) && req.getParameter("id") != null) {
            req.setAttribute("editingUser", userService.getById(parseInt(req.getParameter("id"), -1)));
            req.setAttribute("openEditModal", true);
        }
        req.setAttribute(Constants.ATTR_CONTENT_PAGE, "/WEB-INF/views/admin/user/users.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        User user = new User();
        user.setFullName(req.getParameter("fullName"));
        user.setPhone(req.getParameter("phone"));
        user.setAddress(req.getParameter("address"));
        user.setRole(req.getParameter("role"));
        user.setStatus(req.getParameter("status"));

        if ("add".equals(action)) {
            user.setEmail(req.getParameter("email"));
            user.setPasswordHash(req.getParameter("password"));
            String err = userService.create(user);
            setFlash(req, err == null ? "success" : "error",
                    err == null ? "Đã thêm người dùng." : err);
        } else if ("update".equals(action)) {
            int targetId = parseInt(req.getParameter("id"), -1);
            User currentUser = (User) req.getSession().getAttribute(Constants.SESSION_USER);
            
            // Chặn quản trị viên tự sát (tự giáng quyền hoặc khóa nick)
            if (currentUser != null && currentUser.getId() == targetId) {
                if (!Constants.ROLE_ADMIN.equals(user.getRole()) || !Constants.STATUS_USER_ACTIVE.equals(user.getStatus())) {
                    setFlash(req, "error", "Lỗi: Không thể tự giáng quyền hoặc tự khóa tài khoản của chính mình!");
                    resp.sendRedirect(req.getContextPath() + "/admin/users");
                    return;
                }
            }

            user.setId(targetId);
            boolean ok = userService.update(user);
            setFlash(req, ok ? "success" : "error", ok ? "Đã cập nhật người dùng." : "Không thể cập nhật.");
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
