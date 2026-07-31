package controller.admin;

import model.KichThuoc;
import service.SizeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.Constants;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/kich-thuoc")
public class KichThuocServlet extends HttpServlet {

    private SizeService sizeService = new SizeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            int id = parseInt(req.getParameter("id"), -1);
            setFlash(req, sizeService.delete(id) ? "success" : "error",
                    sizeService.delete(id) ? "Đã xóa kích thước #" + id : "Không thể xóa kích thước #" + id);
            resp.sendRedirect(req.getContextPath() + "/admin/kich-thuoc");
            return;
        }

        List<KichThuoc> list = sizeService.getAll();
        req.setAttribute("listKichThuoc", list);

        if ("edit".equals(action) && req.getParameter("id") != null) {
            req.setAttribute("editingKichThuoc", sizeService.getById(parseInt(req.getParameter("id"), -1)));
            req.setAttribute("openEditModal", true);
        }
        req.setAttribute(Constants.ATTR_CONTENT_PAGE, "/WEB-INF/views/admin/size/sizes.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String name = req.getParameter("name");
        int sortOrder = parseInt(req.getParameter("sortOrder"), 0);
        String status = req.getParameter("status");

        if ("add".equals(action)) {
            KichThuoc kt = new KichThuoc();
            kt.setName(name);
            kt.setSortOrder(sortOrder);
            kt.setStatus(status);
            String err = sizeService.create(kt);
            setFlash(req, err == null ? "success" : "error", err == null ? "Đã thêm kích thước." : err);
        } else if ("update".equals(action)) {
            KichThuoc kt = new KichThuoc();
            kt.setId(parseInt(req.getParameter("id"), -1));
            kt.setName(name);
            kt.setSortOrder(sortOrder);
            kt.setStatus(status);
            boolean ok = sizeService.update(kt);
            setFlash(req, ok ? "success" : "error", ok ? "Đã cập nhật kích thước." : "Không thể cập nhật.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/kich-thuoc");
    }

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private static void setFlash(HttpServletRequest req, String type, String message) {
        req.getSession().setAttribute("flash" + (type.equals("success") ? "Success" : "Error"), message);
    }
}
