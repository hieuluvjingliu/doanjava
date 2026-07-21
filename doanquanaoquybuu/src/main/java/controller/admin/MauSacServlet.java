package controller.admin;

import dao.MauSacDAO;
import model.MauSac;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/mau-sac")
public class MauSacServlet extends HttpServlet {
    private MauSacDAO mauSacDAO = new MauSacDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            mauSacDAO.delete(id);
            resp.sendRedirect(req.getContextPath() + "/admin/mau-sac?msg=deleted");
            return;
        }

        List<MauSac> list = mauSacDAO.getAll();
        req.setAttribute("listMauSac", list);
        req.getRequestDispatcher("/admin/mau-sac.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String name = req.getParameter("name");
        String status = req.getParameter("status");

        MauSac ms = new MauSac();
        ms.setName(name);
        ms.setStatus(status);

        if ("add".equals(action)) {
            mauSacDAO.insert(ms);
            resp.sendRedirect(req.getContextPath() + "/admin/mau-sac?msg=added");
        } else if ("update".equals(action)) {
            ms.setId(Integer.parseInt(req.getParameter("id")));
            mauSacDAO.update(ms);
            resp.sendRedirect(req.getContextPath() + "/admin/mau-sac?msg=updated");
        }
    }
}
