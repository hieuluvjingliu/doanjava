package controller;

import model.SanPham;
import model.DanhMuc;
import service.CatalogService;
import service.CategoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/trang-chu")
public class TrangChuServlet extends HttpServlet {

    private CatalogService catalogService = new CatalogService();
    private CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<DanhMuc> listDanhMuc = categoryService.getAll();
        String categoryParam = req.getParameter("category");
        String keywordParam = req.getParameter("keyword");

        // Lấy sản phẩm theo danh mục hoặc từ khóa (nếu có), ngược lại lấy sản phẩm mới nhất
        List<SanPham> listNewProducts;
        boolean hasFilter = (categoryParam != null && !categoryParam.isBlank())
                || (keywordParam != null && !keywordParam.isBlank());

        if (hasFilter) {
            listNewProducts = catalogService.getCatalog(categoryParam, keywordParam);
        } else {
            listNewProducts = catalogService.getNewestProducts(8);
        }

        String pageTitle = "SẢN PHẨM NỔI BẬT";
        String pageSubtitle = "ĐỒ COSPLAY & ANIME MỚI NHẤT";

        if (categoryParam != null && !categoryParam.isBlank()) {
            try {
                int categoryId = Integer.parseInt(categoryParam);
                DanhMuc dm = categoryService.getById(categoryId);
                pageTitle = dm != null ? dm.getName().toUpperCase() : "DANH MỤC";
                pageSubtitle = "CÁC SẢN PHẨM THUỘC DANH MỤC";
                req.setAttribute("activeCategoryId", categoryId);
            } catch (NumberFormatException ignored) { /* fallback đã được xử lý ở service */ }
        } else if (keywordParam != null && !keywordParam.isBlank()) {
            pageTitle = "KẾT QUẢ TÌM KIẾM";
            pageSubtitle = "Từ khóa: \"" + keywordParam.trim() + "\"";
            req.setAttribute("keyword", keywordParam.trim());
        }

        req.setAttribute("listNewProducts", listNewProducts);
        req.setAttribute("listDanhMuc", listDanhMuc);
        req.setAttribute("pageTitle", pageTitle);
        req.setAttribute("pageSubtitle", pageSubtitle);

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
