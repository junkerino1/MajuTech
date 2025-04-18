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

public class ViewOrderServlet extends HttpServlet {

    @Inject
    private OrderService orderService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Order> orderList = orderService.getOrderByUser(user);

        // Map each order to its list of order items
        Map<Order, List<OrderItem>> orderMap = new LinkedHashMap<>();
        for (Order order : orderList) {
            List<OrderItem> items = orderService.getOrderItemByOrder(order);
            orderMap.put(order, items);
        }

        request.setAttribute("orderMap", orderMap);
        request.getRequestDispatcher("/view/order-history.jsp").forward(request, response);
    }
}
