package controller;

import jakarta.annotation.Resource;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.transaction.UserTransaction;
import java.io.IOException;
import service.AdminService;
import service.CampaignService;

public class DeleteAdminServlet extends HttpServlet {

    @Inject
    private AdminService adminService;

    @Resource
    private UserTransaction utx;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int adminId = Integer.parseInt(request.getParameter("id"));
        String message;
        try {
            utx.begin();
            adminService.deleteAdmin(adminId);
            utx.commit();
            message = "Admin with ID " + adminId + " deleted successfully";
        } catch (Exception e) {
            try {
                utx.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/staff");
    }

}
