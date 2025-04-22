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

public class CreateCampaignServlet extends HttpServlet {

    @Inject
    private ProductService productService;

    @Inject
    private CampaignService campaignService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> productList = productService.getAllProducts();

        request.setAttribute("products", productList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/create-campaign.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String promoName = request.getParameter("promoName");
        double percentageDiscount = Double.parseDouble(request.getParameter("percentageDiscount"));
        String message = "";
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
                    e.printStackTrace();
                }
            }
        }

        // insert into campaign table
        Campaign newCampaign = new Campaign(promoName, startDate, endDate, percentageDiscount);
        campaignService.createNewCampaign(newCampaign);
        int newCampaignId = newCampaign.getId();

        for (Integer productId : productIds) {
            int productIdInt = productId.intValue();
            Product product = productService.getProductById(productIdInt);

            if (product != null) {
                double unitPrice = product.getUnitPrice();
                double discountPrice = unitPrice * (100 - percentageDiscount) / 100;
                CampaignItem newItem = new CampaignItem(newCampaignId, productIdInt, discountPrice);

                campaignService.createCampaignItems(newItem);
            }
        }
        
        message = "Successfully created " + promoName + " campaign.";
        
        request.getSession().setAttribute("campaignMessage", message);
        response.sendRedirect(request.getContextPath() + "/admin/campaign");

    }
}
