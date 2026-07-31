package controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Filter bắt toàn bộ exception chưa được xử lý trong servlet / JSP.
 * Forward về trang {@code /error.jsp} với thông tin gọn để người dùng thấy trang lỗi đẹp.
 */
@WebFilter(urlPatterns = {"/*"})
public class GlobalErrorHandlerFilter implements Filter {

    private static final Logger log = Logger.getLogger(GlobalErrorHandlerFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) { }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        try {
            chain.doFilter(request, response);
        } catch (Throwable ex) {
            HttpServletRequest req = (HttpServletRequest) request;
            HttpServletResponse res = (HttpServletResponse) response;

            log.log(Level.SEVERE,
                    "Unhandled exception for " + req.getRequestURI(), ex);

            if (res.isCommitted()) {
                return;
            }
            res.reset();
            req.setAttribute("statusCode", 500);
            req.setAttribute("errorMessage", ex.getClass().getSimpleName()
                    + ": " + ex.getMessage());
            req.setAttribute("requestUri", req.getRequestURI());

            req.getRequestDispatcher("/error.jsp").forward(req, res);
        }
    }

    @Override
    public void destroy() { }
}
