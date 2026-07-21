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

@WebServlet("/admin/san-pham")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
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
            resp.sendRedirect(req.getContextPath() + "/admin/san-pham?msg=deleted");
            return;
        }

        List<SanPham> list = sanPhamDAO.getAll();
        List<DanhMuc> categories = danhMucDAO.getAll();
        req.setAttribute("listSanPham", list);
        req.setAttribute("listDanhMuc", categories);
        req.getRequestDispatcher("/admin/san-pham.jsp").forward(req, resp);
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

        // Xử lý upload ảnh
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
            sp.setImage(savedImagePath); // Cần có default ảnh nếu chưa chọn
            sanPhamDAO.insert(sp);
            resp.sendRedirect(req.getContextPath() + "/admin/san-pham?msg=added");
        } else if ("update".equals(action)) {
            sp.setId(Integer.parseInt(req.getParameter("id")));
            // Nếu không upload ảnh mới thì giữ nguyên ảnh cũ
            if (imageFileName == null || imageFileName.isEmpty()) {
                sp.setImage(req.getParameter("oldImage"));
            } else {
                sp.setImage(savedImagePath);
            }
            sanPhamDAO.update(sp);
            resp.sendRedirect(req.getContextPath() + "/admin/san-pham?msg=updated");
        }
    }
}
