package controller;

import dao.SanPhamDAO;
import model.SanPham;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"", "/trang-chu"})
public class TrangChuServlet extends HttpServlet {
    private SanPhamDAO sanPhamDAO = new SanPhamDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy danh sách sản phẩm mới nhất (hoặc đang ACTIVE)
        List<SanPham> listNewProducts = sanPhamDAO.getAll();
        
        // Đẩy sang giao diện JSP
        req.setAttribute("listNewProducts", listNewProducts);
        
        // Trỏ về file index.jsp (đây chính là giao diện ICONDENIM clone)
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
