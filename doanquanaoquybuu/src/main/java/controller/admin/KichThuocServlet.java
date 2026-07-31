package controller.admin;

import dao.KichThuocDAO;
import model.KichThuoc;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/kich-thuoc")
public class KichThuocServlet extends HttpServlet {
    private KichThuocDAO kichThuocDAO = new KichThuocDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            kichThuocDAO.delete(id);
            resp.sendRedirect(req.getContextPath() + "/admin/kich-thuoc?msg=deleted");
            return;
        }

        List<KichThuoc> list = kichThuocDAO.getAll();
        req.setAttribute("listKichThuoc", list);

        if ("edit".equals(action) && req.getParameter("id") != null) {
            KichThuoc editing = kichThuocDAO.getById(Integer.parseInt(req.getParameter("id")));
            req.setAttribute("editingKichThuoc", editing);
            req.setAttribute("openEditModal", true);
        }

        req.setAttribute("contentPage", "/WEB-INF/views/admin/size/sizes.jsp");
        req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String name = req.getParameter("name");
        int sortOrder = Integer.parseInt(req.getParameter("sortOrder"));
        String status = req.getParameter("status");

        if ("add".equals(action)) {
            if (name == null || name.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/kich-thuoc?err=invalid_name");
                return;
            }
            KichThuoc existing = kichThuocDAO.getByName(name.trim());
            if (existing != null) {
                resp.sendRedirect(req.getContextPath() + "/admin/kich-thuoc?err=duplicate_size");
                return;
            }
            KichThuoc kt = new KichThuoc();
            kt.setName(name.trim());
            kt.setSortOrder(sortOrder);
            kt.setStatus(status);
            kichThuocDAO.insert(kt);
            resp.sendRedirect(req.getContextPath() + "/admin/kich-thuoc?msg=added");
        } else if ("update".equals(action)) {
            KichThuoc kt = new KichThuoc();
            kt.setName(name);
            kt.setSortOrder(sortOrder);
            kt.setStatus(status);
            kt.setId(Integer.parseInt(req.getParameter("id")));
            kichThuocDAO.update(kt);
            resp.sendRedirect(req.getContextPath() + "/admin/kich-thuoc?msg=updated");
        }
    }
}