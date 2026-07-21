package controller.admin;

import dao.SanPhamChiTietDAO;
import dao.SanPhamDAO;
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
    private SanPhamDAO sanPhamDAO = new SanPhamDAO();
    private MauSacDAO mauSacDAO = new MauSacDAO();
    private KichThuocDAO kichThuocDAO = new KichThuocDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String productIdStr = req.getParameter("productId");
        if (productIdStr == null || productIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/san-pham");
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        List<SanPhamChiTiet> listSPCT = spctDAO.getByProductId(productId);
        
        req.setAttribute("productId", productId);
        req.setAttribute("listSPCT", listSPCT);
        req.setAttribute("listMauSac", mauSacDAO.getAll());
        req.setAttribute("listKichThuoc", kichThuocDAO.getAll());
        
        req.getRequestDispatcher("/admin/san-pham-chi-tiet.jsp").forward(req, resp);
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
        } else if ("update".equals(action)) {
            spct.setId(Integer.parseInt(req.getParameter("id")));
            spctDAO.update(spct);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/san-pham-chi-tiet?productId=" + productId + "&msg=success");
    }
}
