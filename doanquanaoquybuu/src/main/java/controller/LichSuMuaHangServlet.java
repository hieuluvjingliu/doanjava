package controller;

import dao.HoaDonDAO;
import model.HoaDon;
import model.HoaDonChiTiet;
import model.User;

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

    private HoaDonDAO hoaDonDAO = new HoaDonDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("LOGIN_USER");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<HoaDon> orders = hoaDonDAO.getByUserId(user.getId());
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/lich-su-mua-hang.jsp").forward(req, resp);
    }
}
