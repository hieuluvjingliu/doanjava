package controller.admin;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        List<User> list = userDAO.getAll();
        req.setAttribute("listUser", list);
        if ("edit".equals(action) && req.getParameter("id") != null) {
            User editing = userDAO.getById(Integer.parseInt(req.getParameter("id")));
            req.setAttribute("editingUser", editing);
            req.setAttribute("openEditModal", true);
        }
        req.setAttribute("contentPage", "/WEB-INF/views/admin/user/users.jsp");
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
            userDAO.insert(user);
        } else if ("update".equals(action)) {
            user.setId(Integer.parseInt(req.getParameter("id")));
            userDAO.update(user);
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
