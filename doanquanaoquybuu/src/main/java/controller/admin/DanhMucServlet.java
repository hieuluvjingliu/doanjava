package controller.admin;

import model.DanhMuc;
import service.CategoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.Constants;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/danh-muc")
public class DanhMucServlet extends HttpServlet {

    private CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            int id = parseInt(req.getParameter("id"), -1);
            if (categoryService.delete(id)) {
                setFlash(req, "success", "Đã xóa danh mục #" + id);
            } else {
                setFlash(req, "error", "Không thể xóa danh mục #" + id);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/danh-muc");
            return;
        }

        List<DanhMuc> list = categoryService.getAll();
        req.setAttribute("listDanhMuc", list);
        if ("edit".equals(action) && req.getParameter("id") != null) {
            req.setAttribute("editingDanhMuc", categoryService.getById(parseInt(req.getParameter("id"), -1)));
            req.setAttribute("openEditModal", true);
        }
        req.setAttribute(Constants.ATTR_CONTENT_PAGE, "/WEB-INF/views/admin/danhmuc/danhmuc.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        DanhMuc dm = new DanhMuc();
        dm.setName(req.getParameter("name"));
        dm.setDescription(req.getParameter("description"));
        dm.setStatus(req.getParameter("status") != null ? req.getParameter("status") : "ACTIVE");

        if ("add".equals(action)) {
            String err = categoryService.create(dm) ? null : "Không thể thêm danh mục.";
            setFlash(req, err == null ? "success" : "error", err == null ? "Đã thêm danh mục." : err);
        } else if ("update".equals(action)) {
            dm.setId(parseInt(req.getParameter("id"), -1));
            String err = categoryService.update(dm) ? null : "Không thể cập nhật danh mục.";
            setFlash(req, err == null ? "success" : "error", err == null ? "Đã cập nhật danh mục." : err);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/danh-muc");
    }

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private static void setFlash(HttpServletRequest req, String type, String message) {
        req.getSession().setAttribute("flash" + (type.equals("success") ? "Success" : "Error"), message);
    }
}
