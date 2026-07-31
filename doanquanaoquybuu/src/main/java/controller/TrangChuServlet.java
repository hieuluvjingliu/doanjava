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
        List<DanhMuc> listDanhMuc = danhMucDAO.getAll();
        List<SanPham> listNewProducts;
        String pageTitle = "SẢN PHẨM NỔI BẬT";
        String pageSubtitle = "ĐỒ COSPLAY & ANIME MỚI NHẤT";

        String categoryParam = req.getParameter("category");
        String keywordParam = req.getParameter("keyword");

        if (categoryParam != null && !categoryParam.isBlank()) {
            try {
                int categoryId = Integer.parseInt(categoryParam);
                listNewProducts = sanPhamDAO.getByCategoryId(categoryId);
                DanhMuc dm = danhMucDAO.getById(categoryId);
                pageTitle = (dm != null) ? dm.getName().toUpperCase() : "DANH MỤC";
                pageSubtitle = "CÁC SẢN PHẨM THUỘC DANH MỤC";
                req.setAttribute("activeCategoryId", categoryId);
            } catch (NumberFormatException ex) {
                listNewProducts = sanPhamDAO.getAll();
            }
        } else if (keywordParam != null && !keywordParam.isBlank()) {
            listNewProducts = sanPhamDAO.searchByKeyword(keywordParam.trim());
            pageTitle = "KẾT QUẢ TÌM KIẾM";
            pageSubtitle = "Từ khóa: \"" + keywordParam.trim() + "\"";
            req.setAttribute("keyword", keywordParam.trim());
        } else {
            listNewProducts = sanPhamDAO.getAll();
        }

        req.setAttribute("listNewProducts", listNewProducts);
        req.setAttribute("listDanhMuc", listDanhMuc);
        req.setAttribute("pageTitle", pageTitle);
        req.setAttribute("pageSubtitle", pageSubtitle);

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}