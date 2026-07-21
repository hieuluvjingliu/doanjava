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
        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            danhMucDAO.delete(id);
            resp.sendRedirect(req.getContextPath() + "/admin/danh-muc?msg=deleted");
            return;
        }

        List<DanhMuc> list = danhMucDAO.getAll();
        req.setAttribute("listDanhMuc", list);
        req.getRequestDispatcher("/admin/danh-muc.jsp").forward(req, resp);
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
        dm.setStatus(status);

        if ("add".equals(action)) {
            danhMucDAO.insert(dm);
            resp.sendRedirect(req.getContextPath() + "/admin/danh-muc?msg=added");
        } else if ("update".equals(action)) {
            dm.setId(Integer.parseInt(req.getParameter("id")));
            danhMucDAO.update(dm);
            resp.sendRedirect(req.getContextPath() + "/admin/danh-muc?msg=updated");
        }
    }
}
