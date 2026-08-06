package controller.admin;

import model.SanPham;
import model.DanhMuc;
import service.ProductService;
import service.VariantService;
import service.CategoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import utils.Constants;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/products")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class SanPhamServlet extends HttpServlet {

    private ProductService productService = new ProductService();
    private VariantService variantService = new VariantService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            int id = parseInt(req.getParameter("id"), -1);
            boolean ok = productService.delete(id);
            setFlash(req, ok ? "success" : "error",
                    ok ? "Đã xóa sản phẩm #" + id : "Không thể xóa sản phẩm #" + id);
            resp.sendRedirect(req.getContextPath() + "/admin/products");
            return;
        }

        List<DanhMuc> listDanhMuc = new CategoryService().getAll();
        List<SanPham> list = productService.getAll();

        Map<Integer, Integer> totalStockMap = new HashMap<>();
        for (SanPham sp : list) {
            totalStockMap.put(sp.getId(), variantService.getTotalStock(sp.getId()));
        }
        req.setAttribute("totalStockMap", totalStockMap);
        req.setAttribute("listSanPham", list);
        req.setAttribute("listDanhMuc", listDanhMuc);

        if ("edit".equals(action) && req.getParameter("id") != null) {
            req.setAttribute("editingSanPham", productService.getById(parseInt(req.getParameter("id"), -1)));
            req.setAttribute("openEditModal", true);
        }
        req.setAttribute(Constants.ATTR_CONTENT_PAGE, "/WEB-INF/views/admin/product/products.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        int categoryId = parseInt(req.getParameter("categoryId"), -1);
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        double basePrice = parseDouble(req.getParameter("basePrice"), 0);
        String status = req.getParameter("status");
        String imageUrl = req.getParameter("imageUrl");

        SanPham sp = new SanPham();
        sp.setCategoryId(categoryId);
        sp.setName(name);
        sp.setDescription(description);
        sp.setBasePrice(basePrice);
        sp.setStatus(status);

        if ("add".equals(action)) {
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                sp.setImage(imageUrl.trim());
            } else {
                sp.setImage("https://placehold.co/400x400?text=" + (name == null ? "" : name.replace(" ", "+")));
            }
            boolean ok = productService.create(sp);
            setFlash(req, ok ? "success" : "error", ok ? "Đã thêm sản phẩm." : "Không thể thêm sản phẩm.");
        } else if ("update".equals(action)) {
            sp.setId(parseInt(req.getParameter("id"), -1));
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                sp.setImage(imageUrl.trim());
            } else {
                sp.setImage(req.getParameter("oldImage"));
            }
            boolean ok = productService.update(sp);
            setFlash(req, ok ? "success" : "error", ok ? "Đã cập nhật sản phẩm." : "Không thể cập nhật.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private static double parseDouble(String s, double def) {
        try { return Double.parseDouble(s); } catch (Exception e) { return def; }
    }

    private static void setFlash(HttpServletRequest req, String type, String message) {
        req.getSession().setAttribute("flash" + (type.equals("success") ? "Success" : "Error"), message);
    }
}
