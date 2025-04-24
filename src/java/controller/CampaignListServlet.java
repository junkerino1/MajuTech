package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import model.Campaign;
import model.CampaignItem;
import model.Product;
import service.CampaignService;
import service.ProductService;

public class CampaignListServlet extends HttpServlet {

    @Inject
    private CampaignService campaignService;

    @Inject
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Campaign> campaigns = campaignService.getAllCampaign();

        Map<Integer, List<CampaignItem>> campaignItemMap = new HashMap<>();
        Map<Integer, Product> campaignItemProductMap = new HashMap<>();
        Map<Integer, Integer> campaignItemCounts = new HashMap<>();

        for (Campaign campaign : campaigns) {
            int campaignId = campaign.getId();

            List<CampaignItem> items = campaignService.getCampaignItem(campaignId);
            campaignItemMap.put(campaignId, items);
            campaignItemCounts.put(campaignId, items != null ? items.size() : 0);

            if (items != null) {
                for (CampaignItem item : items) {
                    int productId = item.getProductId();
                    Product product = productService.getProductById(productId);
                    campaignItemProductMap.put(item.getId(), product);
                }
            }
        }

        request.setAttribute("campaigns", campaigns);
        request.setAttribute("campaignItemMap", campaignItemMap);
        request.setAttribute("campaignItemCounts", campaignItemCounts);
        request.setAttribute("campaignItemProductMap", campaignItemProductMap);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/campaign.jsp");
        dispatcher.forward(request, response);
    }

}
