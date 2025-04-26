package controller;

import jakarta.annotation.Resource;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.transaction.UserTransaction;
import java.io.IOException;
import service.UserService;
import service.CampaignService;

public class DeleteUserServlet extends HttpServlet {

    @Inject
    private UserService userService;

    @Resource
    private UserTransaction utx;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("id"));
        String message;
        try {
            utx.begin();
            userService.deleteUser(userId);
            utx.commit();
            message = "User with ID " + userId + " deleted successfully";
        } catch (Exception e) {
            try {
                utx.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/customer");
    }

}
