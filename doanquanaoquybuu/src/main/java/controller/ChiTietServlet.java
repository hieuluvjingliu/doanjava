package controller;

import dao.SanPhamDAO;
import dao.SanPhamChiTietDAO;
import model.SanPham;
import model.SanPhamChiTiet;
import dao.MauSacDAO;
import dao.KichThuocDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/chi-tiet")
public class ChiTietServlet extends HttpServlet {
    private SanPhamDAO sanPhamDAO = new SanPhamDAO();
    private SanPhamChiTietDAO spctDAO = new SanPhamChiTietDAO();
    private MauSacDAO mauSacDAO = new MauSacDAO();
    private KichThuocDAO kichThuocDAO = new KichThuocDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        int productId = Integer.parseInt(idStr);
        // Lấy thông tin áo cơ bản
        List<SanPham> allProducts = sanPhamDAO.getAll();
        SanPham product = null;
        for (SanPham sp : allProducts) {
            if (sp.getId() == productId) {
                product = sp;
                break;
            }
        }

        if (product == null) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        // Lấy các biến thể của áo này
        List<SanPhamChiTiet> variants = spctDAO.getByProductId(productId);

        req.setAttribute("product", product);
        req.setAttribute("variants", variants);
        req.setAttribute("listMauSac", mauSacDAO.getAll());
        req.setAttribute("listKichThuoc", kichThuocDAO.getAll());

        req.getRequestDispatcher("/chi-tiet.jsp").forward(req, resp);
    }
}
