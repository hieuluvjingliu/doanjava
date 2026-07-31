package controller.admin;

import model.SanPhamChiTiet;
import service.ColorService;
import service.SizeService;
import service.VariantService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.Constants;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/san-pham-chi-tiet")
public class SanPhamChiTietServlet extends HttpServlet {

    private VariantService variantService = new VariantService();
    private ColorService colorService = new ColorService();
    private SizeService sizeService = new SizeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String productIdStr = req.getParameter("productId");

        if ("delete".equals(action) && req.getParameter("id") != null) {
            int id = parseInt(req.getParameter("id"), -1);
            boolean ok = variantService.delete(id);
            setFlash(req, ok ? "success" : "error",
                    ok ? "Đã xóa biến thể #" + id : "Không thể xóa biến thể #" + id);
            resp.sendRedirect(req.getContextPath() + "/admin/san-pham-chi-tiet?productId=" + productIdStr);
            return;
        }

        if (productIdStr == null || productIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/products");
            return;
        }

        int productId = parseInt(productIdStr, -1);
        List<SanPhamChiTiet> listSPCT = variantService.getByProductId(productId);

        req.setAttribute("productId", productId);
        req.setAttribute("listSPCT", listSPCT);
        req.setAttribute("listMauSac", colorService.getAll());
        req.setAttribute("listKichThuoc", sizeService.getAll());

        if ("edit".equals(action) && req.getParameter("id") != null) {
            int variantId = parseInt(req.getParameter("id"), -1);
            req.setAttribute("editingSPCT", variantService.findInList(listSPCT, variantId));
            req.setAttribute("openEditModal", true);
        }

        req.setAttribute(Constants.ATTR_CONTENT_PAGE, "/WEB-INF/views/admin/variant/variants.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        int productId = parseInt(req.getParameter("productId"), -1);

        if (productId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/products");
            return;
        }

        SanPhamChiTiet spct = new SanPhamChiTiet();
        spct.setProductId(productId);
        spct.setColorId(parseInt(req.getParameter("colorId"), -1));
        spct.setSizeId(parseInt(req.getParameter("sizeId"), -1));
        spct.setSku(req.getParameter("sku"));

        String priceStr = req.getParameter("price");
        if (priceStr != null && !priceStr.isEmpty()) {
            try {
                spct.setPrice(Double.parseDouble(priceStr));
            } catch (NumberFormatException e) {
                spct.setPrice(null);
            }
        }

        spct.setQuantity(parseInt(req.getParameter("quantity"), 0));
        spct.setImage(req.getParameter("image"));
        spct.setStatus(req.getParameter("status"));

        if ("add".equals(action)) {
            boolean ok = variantService.create(spct);
            setFlash(req, ok ? "success" : "error", ok ? "Đã thêm biến thể." : "Không thể thêm biến thể.");
        } else if ("update".equals(action)) {
            spct.setId(parseInt(req.getParameter("id"), -1));
            boolean ok = variantService.update(spct);
            setFlash(req, ok ? "success" : "error", ok ? "Đã cập nhật biến thể." : "Không thể cập nhật.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/san-pham-chi-tiet?productId=" + productId);
    }

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private static void setFlash(HttpServletRequest req, String type, String message) {
        req.getSession().setAttribute("flash" + (type.equals("success") ? "Success" : "Error"), message);
    }
}
