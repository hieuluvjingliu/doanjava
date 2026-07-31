package controller.admin;

import model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        User user = (User) session.getAttribute("LOGIN_USER");
        // #region agent log
        try {
            java.io.FileWriter fw = new java.io.FileWriter("d:\\Spring\\debug-386ec2.log", true);
            java.io.PrintWriter pw = new java.io.PrintWriter(fw);
            String role = (user != null) ? user.getRole() : "NULL";
            boolean allow = user != null && ("ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole()));
            pw.println("{\"sessionId\":\"386ec2\",\"id\":\"log_" + System.currentTimeMillis() + "\",\"timestamp\":" + System.currentTimeMillis() + ",\"location\":\"AdminFilter.java:18\",\"message\":\"AdminFilter invoked\",\"data\":{\"uri\":\"" + req.getRequestURI() + "\",\"user_null\":" + (user == null) + ",\"role\":\"" + role + "\",\"allow\":" + allow + "},\"runId\":\"run1\",\"hypothesisId\":\"H1\"}");
            pw.close();
            fw.close();
        } catch (Exception e) {}
        // #endregion
        if (user != null && ("ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole()))) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }
}
