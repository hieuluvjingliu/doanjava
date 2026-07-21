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
        req.getRequestDispatcher("/admin/kich-thuoc.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String name = req.getParameter("name");
        int sortOrder = Integer.parseInt(req.getParameter("sortOrder"));
        String status = req.getParameter("status");

        KichThuoc kt = new KichThuoc();
        kt.setName(name);
        kt.setSortOrder(sortOrder);
        kt.setStatus(status);

        if ("add".equals(action)) {
            kichThuocDAO.insert(kt);
            resp.sendRedirect(req.getContextPath() + "/admin/kich-thuoc?msg=added");
        } else if ("update".equals(action)) {
            kt.setId(Integer.parseInt(req.getParameter("id")));
            kichThuocDAO.update(kt);
            resp.sendRedirect(req.getContextPath() + "/admin/kich-thuoc?msg=updated");
        }
    }
}
