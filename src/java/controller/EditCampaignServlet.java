package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;
import model.Campaign;
import model.Product;
import model.CampaignItem;
import service.CampaignService;
import service.ProductService;

public class EditCampaignServlet extends HttpServlet {

    @Inject
    private ProductService productService;

    @Inject
    private CampaignService campaignService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int campaignId = Integer.parseInt(request.getParameter("id"));

        List<Product> productList = productService.getAllProducts();
        Campaign campaign = campaignService.getCampaignById(campaignId);
        List<CampaignItem> campaignItemList = campaignService.getCampaignItem(campaignId);
        List<Integer> items = new ArrayList<>();

        for (CampaignItem item : campaignItemList) {
            items.add(item.getProductId());
        }

        request.setAttribute("products", productList);
        request.setAttribute("campaign", campaign);
        request.setAttribute("items", items);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/edit-campaign.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String message = "";
        int campaignId = Integer.parseInt(request.getParameter("campaignId"));
        
        // remove existing campaignItem
        campaignService.deleteCampaignItem(campaignId);
        
        String promoName = request.getParameter("promoName");
        Double percentageDiscount = Double.valueOf(request.getParameter("percentageDiscount"));

        // Parse the start and end dates as LocalDate
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate startDate = null;
        LocalDate endDate = null;

        try {
            startDate = LocalDate.parse(request.getParameter("startDate"), formatter);
            endDate = LocalDate.parse(request.getParameter("endDate"), formatter);
        } catch (DateTimeParseException e) {
            // Handle invalid date format
            response.getWriter().write("Invalid date format");
            return;
        }

        // Retrieve the list of product IDs
        String promoItemList = request.getParameter("promoItem");
        List<Integer> productIds = new ArrayList<>();

        if (promoItemList != null && !promoItemList.isEmpty()) {
            // Remove brackets and whitespace
            promoItemList = promoItemList.replaceAll("[\\[\\]\\s\"]", "");
            System.out.println("items:" + promoItemList);

            // Split by comma and convert to integers
            String[] idArray = promoItemList.split(",");
            for (String idStr : idArray) {
                try {
                    productIds.add(Integer.parseInt(idStr));
                } catch (NumberFormatException e) {
                    message = "Error editing campaign";
                }
            }
            
        }

        // update campaign table
        Campaign campaign = new Campaign(promoName, startDate, endDate, percentageDiscount);
        campaign.setId(campaignId);
        
        campaignService.editCampaign(campaign);

        for (Integer productId : productIds) {

            int productIdInt = productId.intValue();
            Product product = productService.getProductById(productIdInt);

            if (product != null) {
                double unitPrice = product.getUnitPrice();
                double discountPrice = unitPrice * (100 - percentageDiscount) / 100;

                product.setStatus("promotion");
                productService.updateProduct(product);

                CampaignItem newItem = new CampaignItem(campaignId, productIdInt, discountPrice);

                campaignService.createCampaignItems(newItem);

                message = "Successfully updated product details";
            }
        }
        
        request.getSession().setAttribute("campaignMessage", message);
        response.sendRedirect(request.getContextPath() + "/admin/campaign");
        
        
    }
    
}
