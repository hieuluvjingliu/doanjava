package controller;

import dao.SanPhamDAO;
import dao.DanhMucDAO;
import model.SanPham;
import model.DanhMuc;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/trang-chu")
public class TrangChuServlet extends HttpServlet {
    private SanPhamDAO sanPhamDAO = new SanPhamDAO();
    private DanhMucDAO danhMucDAO = new DanhMucDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<SanPham> listNewProducts = sanPhamDAO.getAll();
        List<DanhMuc> listDanhMuc = danhMucDAO.getAll();

        req.setAttribute("listNewProducts", listNewProducts);
        req.setAttribute("listDanhMuc", listDanhMuc);

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
