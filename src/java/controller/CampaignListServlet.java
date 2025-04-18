package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import model.Campaign;
import model.CampaignItem;
import service.CampaignService;

public class CampaignListServlet extends HttpServlet {

    @Inject
    private CampaignService campaignService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Campaign> campaigns = campaignService.getAllCampaign();

        // Map to hold campaignId -> item count
        Map<Integer, Integer> campaignItemCounts = new HashMap<>();

        for (Campaign campaign : campaigns) {
            int campaignId = campaign.getId();
            List<CampaignItem> items = campaignService.getCampaignItem(campaignId);
            int count = items != null ? items.size() : 0;
            campaignItemCounts.put(campaignId, count);
        }

        // Set the list and map as request attributes
        request.setAttribute("campaigns", campaigns);
        request.setAttribute("campaignItemCounts", campaignItemCounts);

        // Forward to JSP page to display the campaigns
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/campaign.jsp");
        dispatcher.forward(request, response);
    }
}
