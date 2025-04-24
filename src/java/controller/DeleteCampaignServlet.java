package controller;

import jakarta.annotation.Resource;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.transaction.UserTransaction;
import java.io.IOException;
import service.ProductService;
import service.CampaignService;

public class DeleteCampaignServlet extends HttpServlet {

    @Inject
    private CampaignService campaignService;

    @Resource
    private UserTransaction utx;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int campaignId = Integer.parseInt(request.getParameter("id"));
        String message;
        try {
            utx.begin();
            campaignService.deleteCampaign(campaignId);
            utx.commit();
            message = "Campaign with ID " + campaignId + " deleted successfully";
        } catch (Exception e) {
            try {
                utx.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            message = "Failed to delete campaign";
        }
        
        request.getSession().setAttribute("message", message);
        response.sendRedirect(request.getContextPath() + "/admin/campaign");
    }

}
