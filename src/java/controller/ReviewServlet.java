package controller;

import jakarta.annotation.Resource;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.transaction.UserTransaction;
import java.io.IOException;
import java.io.PrintWriter;
import service.*;
import model.*;

public class ReviewServlet extends HttpServlet {

    @Inject
    private ProductService productService;

    @Inject
    private OrderService orderService;

    @Inject
    private ReviewService reviewService;

    @Resource
    private UserTransaction utx;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set JSON response type
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        int productId = Integer.parseInt(request.getParameter("productId"));
        Product product = productService.getProductById(productId);
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        Order order = orderService.getOrderById(orderId);
        int rating = Integer.parseInt(request.getParameter("rating"));
        String reviewText = request.getParameter("reviewText");
        String username = request.getParameter("username");
        boolean anonymous = Boolean.parseBoolean(request.getParameter("anonymous"));

        if (anonymous) {
            username = maskUsername(username);
        }

        try {
            Review review = new Review(order, product, username, rating, reviewText);

            utx.begin();
            reviewService.addReview(review);
            utx.commit();

            out.print("{\"success\": true}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"" + e.getMessage().replace("\"", "'") + "\"}");
        } finally {
            out.flush();
            out.close();
        }

    }

    private String maskUsername(String username) {
        if (username == null || username.length() < 2) {
            return "*".repeat(username.length());
        }
        return username.charAt(0) + "*".repeat(username.length() - 1);
    }

}
