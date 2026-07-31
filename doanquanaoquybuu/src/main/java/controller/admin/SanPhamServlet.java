package controller.admin;

import dao.SanPhamDAO;
import dao.DanhMucDAO;
import model.SanPham;
import model.DanhMuc;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@WebServlet("/admin/products")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class SanPhamServlet extends HttpServlet {
    private SanPhamDAO sanPhamDAO = new SanPhamDAO();
    private DanhMucDAO danhMucDAO = new DanhMucDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            sanPhamDAO.delete(id);
            resp.sendRedirect(req.getContextPath() + "/admin/products?msg=deleted");
            return;
        }

        List<SanPham> list = sanPhamDAO.getAll();
        List<DanhMuc> categories = danhMucDAO.getAll();
        req.setAttribute("listSanPham", list);
        req.setAttribute("listDanhMuc", categories);
        req.setAttribute("contentPage", "/WEB-INF/views/admin/product/products.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        int categoryId = Integer.parseInt(req.getParameter("categoryId"));
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        double basePrice = Double.parseDouble(req.getParameter("basePrice"));
        String status = req.getParameter("status");
        String imageUrl = req.getParameter("imageUrl"); // URL ảnh (vd: https://placehold.co/600x400)

        Part filePart = req.getPart("imageFile");
        String imageFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        String savedImagePath = "";
        if (imageFileName != null && !imageFileName.isEmpty()) {
            filePart.write(uploadPath + File.separator + imageFileName);
            savedImagePath = "uploads/" + imageFileName;
        }

        SanPham sp = new SanPham();
        sp.setCategoryId(categoryId);
        sp.setName(name);
        sp.setDescription(description);
        sp.setBasePrice(basePrice);
        sp.setStatus(status);

        if ("add".equals(action)) {
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                sp.setImage(imageUrl.trim());
            } else if (!savedImagePath.isEmpty()) {
                sp.setImage(savedImagePath);
            } else {
                sp.setImage("https://placehold.co/400x400?text=" + name.replace(" ", "+"));
            }
            sanPhamDAO.insert(sp);
            resp.sendRedirect(req.getContextPath() + "/admin/products?msg=added");
        } else if ("update".equals(action)) {
            sp.setId(Integer.parseInt(req.getParameter("id")));
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                sp.setImage(imageUrl.trim());
            } else if (imageFileName != null && !imageFileName.isEmpty()) {
                sp.setImage(savedImagePath);
            } else {
                sp.setImage(req.getParameter("oldImage"));
            }
            sanPhamDAO.update(sp);
            resp.sendRedirect(req.getContextPath() + "/admin/products?msg=updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        }
    }
}
