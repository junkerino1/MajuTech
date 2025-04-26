package utils;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Admin;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String path = request.getRequestURI().substring(request.getContextPath().length());

        if (path.equals("/admin/login")) {
            chain.doFilter(req, res);
            return;
        }

        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;

        if (admin != null) {
            session.setAttribute("adminRole", admin.getRole());

            if (path.startsWith("/admin/staff")) {
                if (!"manager".equals(admin.getRole())) {
                    request.getRequestDispatcher("/view/403.jsp").forward(request, response);
                    return;
                }
            }

            chain.doFilter(request, response);

        } else {
            response.sendRedirect(request.getContextPath() + "/admin/login");
        }
    }
}
