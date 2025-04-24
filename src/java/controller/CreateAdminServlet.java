package controller;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Admin;
import service.AdminService;

public class CreateAdminServlet extends HttpServlet {

    @Inject
    private AdminService adminService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/view/add-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get data from the form
        String name = request.getParameter("name");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        Admin admin = new Admin(name, password, role);
        
        adminService.createAdmin(admin);
        
        response.sendRedirect(request.getContextPath() + "/admin/staff");
    }
}