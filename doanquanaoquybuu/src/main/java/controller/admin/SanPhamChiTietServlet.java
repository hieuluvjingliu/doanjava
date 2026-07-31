package controller.admin;

import dao.SanPhamChiTietDAO;
import dao.KichThuocDAO;
import dao.MauSacDAO;
import model.SanPhamChiTiet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/san-pham-chi-tiet")
public class SanPhamChiTietServlet extends HttpServlet {
    private SanPhamChiTietDAO spctDAO = new SanPhamChiTietDAO();
    private MauSacDAO mauSacDAO = new MauSacDAO();
    private KichThuocDAO kichThuocDAO = new KichThuocDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String productIdStr = req.getParameter("productId");

        if ("delete".equals(action) && req.getParameter("id") != null) {
            int id = Integer.parseInt(req.getParameter("id"));
            spctDAO.delete(id);
            resp.sendRedirect(req.getContextPath() + "/admin/san-pham-chi-tiet?productId=" + productIdStr + "&msg=deleted");
            return;
        }

        if (productIdStr == null || productIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/products");
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        List<SanPhamChiTiet> listSPCT = spctDAO.getByProductId(productId);

        req.setAttribute("productId", productId);
        req.setAttribute("listSPCT", listSPCT);
        req.setAttribute("listMauSac", mauSacDAO.getAll());
        req.setAttribute("listKichThuoc", kichThuocDAO.getAll());

        if ("edit".equals(action) && req.getParameter("id") != null) {
            int variantId = Integer.parseInt(req.getParameter("id"));
            for (SanPhamChiTiet spct : listSPCT) {
                if (spct.getId() == variantId) {
                    req.setAttribute("editingSPCT", spct);
                    req.setAttribute("openEditModal", true);
                    break;
                }
            }
        }

        req.setAttribute("contentPage", "/WEB-INF/views/admin/variant/variants.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        int productId = Integer.parseInt(req.getParameter("productId"));

        SanPhamChiTiet spct = new SanPhamChiTiet();
        spct.setProductId(productId);
        spct.setColorId(Integer.parseInt(req.getParameter("colorId")));
        spct.setSizeId(Integer.parseInt(req.getParameter("sizeId")));
        spct.setSku(req.getParameter("sku"));

        String priceStr = req.getParameter("price");
        if (priceStr != null && !priceStr.isEmpty()) {
            spct.setPrice(Double.parseDouble(priceStr));
        } else {
            spct.setPrice(null);
        }

        spct.setQuantity(Integer.parseInt(req.getParameter("quantity")));
        spct.setImage(req.getParameter("image"));
        spct.setStatus(req.getParameter("status"));

        if ("add".equals(action)) {
            spctDAO.insert(spct);
            resp.sendRedirect(req.getContextPath() + "/admin/san-pham-chi-tiet?productId=" + productId + "&msg=success");
        } else if ("update".equals(action)) {
            spct.setId(Integer.parseInt(req.getParameter("id")));
            spctDAO.update(spct);
            resp.sendRedirect(req.getContextPath() + "/admin/san-pham-chi-tiet?productId=" + productId + "&msg=updated");
        }
    }
}