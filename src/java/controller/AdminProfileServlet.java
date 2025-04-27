package controller;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Admin;
import service.AdminService;

public class AdminProfileServlet extends HttpServlet {

    @Inject
    private AdminService adminService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/view/admin-profile.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String oldPw = request.getParameter("currentPassword");
        String newPw = request.getParameter("newPassword");

        Admin admin = (Admin) request.getSession().getAttribute("admin");
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String oriPw = admin.getPassword();

        if (oriPw.equals(oldPw)) {
            admin.setPassword(newPw);
            adminService.updateAdmin(admin);
            request.getSession().setAttribute("message", "Password updated successfully!");
        } else {
            request.getSession().setAttribute("error", "Current password is incorrect.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/profile");
    }

}
