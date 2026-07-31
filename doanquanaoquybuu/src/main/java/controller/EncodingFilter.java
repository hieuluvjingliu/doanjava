package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;

@WebFilter("/*")
public class EncodingFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        // Chỉ set Content-Type cho response chưa được set và KHÔNG phải static assets.
        // Tránh ghi đè Content-Type đúng (text/css, application/javascript, image/...) do Tomcat đặt cho static files.
        String ct = response.getContentType();
        if ((ct == null || !ct.toLowerCase().contains("charset")) && !isStaticAsset(request)) {
            response.setContentType("text/html; charset=UTF-8");
        }

        chain.doFilter(request, response);
    }

    private boolean isStaticAsset(ServletRequest request) {
        if (!(request instanceof HttpServletRequest req)) {
            return false;
        }
        String uri = req.getRequestURI();
        String lower = uri.toLowerCase();
        return lower.endsWith(".css")
                || lower.endsWith(".js")
                || lower.endsWith(".png")
                || lower.endsWith(".jpg")
                || lower.endsWith(".jpeg")
                || lower.endsWith(".gif")
                || lower.endsWith(".svg")
                || lower.endsWith(".webp")
                || lower.endsWith(".ico")
                || lower.endsWith(".woff")
                || lower.endsWith(".woff2")
                || lower.endsWith(".ttf")
                || lower.endsWith(".eot");
    }

    @Override
    public void destroy() {}
}
