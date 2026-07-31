package controller.admin;

import model.MauSac;
import service.ColorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.Constants;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/mau-sac")
public class MauSacServlet extends HttpServlet {

    private ColorService colorService = new ColorService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            int id = parseInt(req.getParameter("id"), -1);
            boolean ok = colorService.delete(id);
            setFlash(req, ok ? "success" : "error",
                    ok ? "Đã xóa màu sắc #" + id : "Không thể xóa màu sắc #" + id);
            resp.sendRedirect(req.getContextPath() + "/admin/mau-sac");
            return;
        }

        List<MauSac> list = colorService.getAll();
        req.setAttribute("listMauSac", list);

        if ("edit".equals(action) && req.getParameter("id") != null) {
            req.setAttribute("editingMauSac", colorService.getById(parseInt(req.getParameter("id"), -1)));
            req.setAttribute("openEditModal", true);
        }
        req.setAttribute(Constants.ATTR_CONTENT_PAGE, "/WEB-INF/views/admin/color/colors.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        MauSac ms = new MauSac();
        ms.setName(req.getParameter("name"));
        ms.setStatus(req.getParameter("status"));

        if ("add".equals(action)) {
            boolean ok = colorService.create(ms);
            setFlash(req, ok ? "success" : "error", ok ? "Đã thêm màu sắc." : "Không thể thêm màu sắc.");
        } else if ("update".equals(action)) {
            ms.setId(parseInt(req.getParameter("id"), -1));
            boolean ok = colorService.update(ms);
            setFlash(req, ok ? "success" : "error", ok ? "Đã cập nhật màu sắc." : "Không thể cập nhật.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/mau-sac");
    }

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private static void setFlash(HttpServletRequest req, String type, String message) {
        req.getSession().setAttribute("flash" + (type.equals("success") ? "Success" : "Error"), message);
    }
}
