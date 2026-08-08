package controller;

import model.SanPham;
import service.CatalogService;
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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keywordParam = req.getParameter("keyword");

        List<SanPham> listNewProducts;
        String pageTitle = "SẢN PHẨM NỔI BẬT";
        String pageSubtitle = "ĐỒ COSPLAY & ANIME MỚI NHẤT";

        if (keywordParam != null && !keywordParam.isBlank()) {
            // Khi có từ khóa: tìm kiếm theo keyword
            listNewProducts = catalogService.getCatalog(null, keywordParam);
            pageTitle = "KẾT QUẢ TÌM KIẾM";
            pageSubtitle = "Từ khóa: \"" + keywordParam.trim() + "\"";
            req.setAttribute("keyword", keywordParam.trim());
        } else {
            // Trang chủ mặc định: lấy 8 sản phẩm mới nhất (id DESC) để sản phẩm
            // vừa thêm ở admin luôn xuất hiện ngay.
            listNewProducts = catalogService.getNewestProducts(8);
        }

        req.setAttribute("listNewProducts", listNewProducts);
        req.setAttribute("pageTitle", pageTitle);
        req.setAttribute("pageSubtitle", pageSubtitle);

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
