package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Product;
import service.ProductService;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

public class ShopServlet extends HttpServlet {

    @Inject
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            List<Product> products = productService.getAllProducts();
            request.setAttribute("products", products);
            request.getRequestDispatcher("/view/products.jsp").forward(request, response);
        } else {
            String productIdString = pathInfo.substring(1);
            try {
                List<Product> products = productService.getAllProducts();
                Collections.shuffle(products);
                List<Product> featuredProducts = products.size() > 8
                        ? products.subList(0, 8)
                        : products;

                request.setAttribute("featuredProducts", featuredProducts);

                int productId = Integer.parseInt(productIdString);
                Product product = productService.getProductById(productId);

                if (product != null) {
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("/view/product-details.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }

}
