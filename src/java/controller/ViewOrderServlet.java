package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import model.Order;
import model.OrderItem;
import model.User;
import service.OrderService;
import service.ReviewService;

public class ViewOrderServlet extends HttpServlet {

    @Inject
    private OrderService orderService;
    
    @Inject
    private ReviewService reviewService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Order> orderList = orderService.getOrderByUser(user);

        Map<Order, List<OrderItem>> orderMap = new LinkedHashMap<>();
        Map<OrderItem, Boolean> reviewStatusMap = new HashMap<>();

        for (Order order : orderList) {
            List<OrderItem> items = orderService.getOrderItemByOrder(order);
            orderMap.put(order, items);

            for (OrderItem item : items) {
                int orderId = order.getOrderId();
                int productId = item.getProduct().getId();

                boolean reviewExists = reviewService.reviewExists(orderId, productId);
                reviewStatusMap.put(item, reviewExists);
            }
        }

        request.setAttribute("orderMap", orderMap);
        request.setAttribute("reviewStatusMap", reviewStatusMap); 
        request.getRequestDispatcher("/view/order-history.jsp").forward(request, response);
    }
}
