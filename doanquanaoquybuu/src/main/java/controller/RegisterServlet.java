package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String password = req.getParameter("password");

        // Set mặc định role là CUSTOMER và status là ACTIVE
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);
        user.setPasswordHash(password); // Thực tế nên hash password, nhưng làm theo logic hiện có
        user.setRole("CUSTOMER");
        user.setStatus("ACTIVE");

        boolean success = userDAO.insert(user);

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/login?msg=register_success");
        } else {
            req.setAttribute("error", "Đăng ký thất bại, email có thể đã tồn tại!");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
