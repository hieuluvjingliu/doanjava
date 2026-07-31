package controller.admin;

import dao.DanhMucDAO;
import model.DanhMuc;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/danh-muc")
public class DanhMucServlet extends HttpServlet {
    private DanhMucDAO danhMucDAO = new DanhMucDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        // #region agent log
        try {
            java.io.FileWriter fw = new java.io.FileWriter("d:\\Spring\\debug-386ec2.log", true);
            java.io.PrintWriter pw = new java.io.PrintWriter(fw);
            pw.println("{\"sessionId\":\"386ec2\",\"id\":\"log_" + System.currentTimeMillis() + "\",\"timestamp\":" + System.currentTimeMillis() + ",\"location\":\"DanhMucServlet.java:20\",\"message\":\"DanhMucServlet.doGet\",\"data\":{\"action\":\"" + (action == null ? "NULL" : action) + "\",\"id\":\"" + req.getParameter("id") + "\"},\"runId\":\"run2\",\"hypothesisId\":\"H3\"}");
            pw.close();
            fw.close();
        } catch (Exception e) {}
        // #endregion
        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            danhMucDAO.delete(id);
            resp.sendRedirect(req.getContextPath() + "/admin/danh-muc");
            return;
        }

        List<DanhMuc> list = danhMucDAO.getAll();
        req.setAttribute("listDanhMuc", list);
        if ("edit".equals(action) && req.getParameter("id") != null) {
            DanhMuc editing = danhMucDAO.getById(Integer.parseInt(req.getParameter("id")));
            req.setAttribute("editingDanhMuc", editing);
            req.setAttribute("openEditModal", true);
        }
        req.setAttribute("contentPage", "/WEB-INF/views/admin/danhmuc/danhmuc.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String status = req.getParameter("status");

        DanhMuc dm = new DanhMuc();
        dm.setName(name);
        dm.setDescription(description);
        dm.setStatus(status != null ? status : "ACTIVE");

        if ("add".equals(action)) {
            danhMucDAO.insert(dm);
        } else if ("update".equals(action)) {
            dm.setId(Integer.parseInt(req.getParameter("id")));
            danhMucDAO.update(dm);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/danh-muc");
    }
}
