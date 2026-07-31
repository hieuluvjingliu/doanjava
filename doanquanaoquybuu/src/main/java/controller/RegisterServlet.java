package controller;

import service.AuthService;
import utils.Constants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private AuthService authService = new AuthService();

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

        String error = authService.register(fullName, email, phone, address, password);

        if (error == null) {
            resp.sendRedirect(req.getContextPath() + "/login?msg=register_success");
        } else {
            req.setAttribute(Constants.ATTR_ERROR, error);
            req.setAttribute("enteredFullName", fullName);
            req.setAttribute("enteredEmail", email);
            req.setAttribute("enteredPhone", phone);
            req.setAttribute("enteredAddress", address);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
