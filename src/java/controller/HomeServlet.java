package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Product;
import service.ProductService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import model.Campaign;
import service.CampaignService;

public class HomeServlet extends HttpServlet {

    @Inject
    private ProductService productService;

    @Inject
    private CampaignService campaignService;

    @Override
    public void init() {
        campaignService.checkOngoingCampaign();
        System.out.println("checked");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = productService.getAllProducts();
        System.out.println("products:" + products);

        // Shuffle for randomness
        Collections.shuffle(products);

        // Limit to 8
        List<Product> featuredProducts = products.size() > 8
                ? products.subList(0, 8)
                : products;

        Campaign ongoingCampaign = campaignService.getOngoingCampaign();
        if (ongoingCampaign != null) {
            LocalDate endDate = ongoingCampaign.getDateEnd();
            request.setAttribute("endDate", endDate);
        }

        request.setAttribute("promoProducts", products);
        request.setAttribute("featuredProducts", featuredProducts);
        request.getRequestDispatcher("/view/home.jsp").forward(request, response);
    }

}
