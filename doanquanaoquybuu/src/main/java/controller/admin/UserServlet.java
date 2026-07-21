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

@WebServlet("/admin/user")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<User> list = userDAO.getAll();
        req.setAttribute("listUser", list);
        req.getRequestDispatcher("/admin/user.jsp").forward(req, resp);
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
            user.setPasswordHash(req.getParameter("password")); // Demo chưa băm password
            userDAO.insert(user);
            resp.sendRedirect(req.getContextPath() + "/admin/user?msg=added");
        } else if ("update".equals(action)) {
            user.setId(Integer.parseInt(req.getParameter("id")));
            userDAO.update(user);
            resp.sendRedirect(req.getContextPath() + "/admin/user?msg=updated");
        }
    }
}
