package controller;

import model.SanPham;
import model.SanPhamChiTiet;
import service.CatalogService;
import service.ColorService;
import service.SizeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/chi-tiet")
public class ChiTietServlet extends HttpServlet {

    private CatalogService catalogService = new CatalogService();
    private ColorService colorService = new ColorService();
    private SizeService sizeService = new SizeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        SanPham product = catalogService.getProductById(productId);
        if (product == null) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        List<SanPhamChiTiet> variants = catalogService.getVariants(productId);

        req.setAttribute("product", product);
        req.setAttribute("variants", variants);
        req.setAttribute("listMauSac", colorService.getAll());
        req.setAttribute("listKichThuoc", sizeService.getAll());

        req.getRequestDispatcher("/chi-tiet.jsp").forward(req, resp);
    }
}
