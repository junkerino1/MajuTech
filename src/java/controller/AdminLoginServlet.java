package controller;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Admin;
import service.AdminService;

public class AdminLoginServlet extends HttpServlet {

    @Inject
    private AdminService adminService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Admin admin = adminService.findByUsername(username);

            if (admin != null && admin.getPassword().equals(password)) {
                HttpSession session = request.getSession();

                session.setAttribute("admin", admin);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");

            } else {
                request.setAttribute("message", "Invalid username or password");
                request.getRequestDispatcher("/view/admin-login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("message", "Invalid username or password");
            request.getRequestDispatcher("/view/admin-login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/admin-login.jsp").forward(request, response);
    }
}
