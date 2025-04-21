package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Product;
import service.ProductService;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;
import service.CampaignService;

public class ShopServlet extends HttpServlet {

    @Override
    public void init() {
        campaignService.checkOngoingCampaign();
    }
    
    @Inject
    private CampaignService campaignService;

    @Inject
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String searchQuery = request.getParameter("search");
        String minPrice = request.getParameter("min");
        String maxPrice = request.getParameter("max");
        String[] categoryIds = request.getParameterValues("categoryId");

        try {
            // Display specific product page by ID
            if (pathInfo != null && pathInfo.matches("/\\d+")) {
                int productId = Integer.parseInt(pathInfo.substring(1));
                Product product = productService.getProductById(productId);
                if (product != null) {
                    List<Product> products = productService.getAllProducts();

                    // Shuffle the products and fetch a maximum of 4 products for featuring
                    Collections.shuffle(products);
                    List<Product> featuredProducts = products.subList(0, Math.min(4, products.size()));

                    // Set attribute
                    request.setAttribute("featuredProducts", featuredProducts);
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("/view/product-details.jsp").forward(request, response);
                    return;
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
            }

            List<Product> products = productService.getAllProducts();

            // Default to all products if no filters are applied
            List<Product> filteredProducts = new ArrayList<>(products);

            // Search by keyword (if any)
            if (searchQuery != null && !searchQuery.isBlank()) {
                filteredProducts = filteredProducts.stream()
                        .filter(p -> p.getProductName().toLowerCase().contains(searchQuery.trim().toLowerCase())
                        || p.getDescription().toLowerCase().contains(searchQuery.trim().toLowerCase()))
                        .collect(Collectors.toList());
            }

            // Apply price filter if any
            if (minPrice != null && !minPrice.isEmpty()) {
                double min = Double.parseDouble(minPrice);
                filteredProducts = filteredProducts.stream()
                        .filter(p -> p.getUnitPrice() >= min)
                        .collect(Collectors.toList());
            }

            if (maxPrice != null && !maxPrice.isEmpty()) {
                double max = Double.parseDouble(maxPrice);
                filteredProducts = filteredProducts.stream()
                        .filter(p -> p.getUnitPrice() <= max)
                        .collect(Collectors.toList());
            }

            // Apply category filter if any
            if (categoryIds != null && categoryIds.length > 0) {
                Set<String> selectedCategories = new HashSet<>(Arrays.asList(categoryIds));
                filteredProducts = filteredProducts.stream()
                        .filter(p -> selectedCategories.contains(String.valueOf(p.getCategoryId())))
                        .collect(Collectors.toList());
            }

            // Set filtered products as request attribute
            request.setAttribute("products", filteredProducts);
            request.getRequestDispatcher("/view/products.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameter format.");
        }
    }

}
