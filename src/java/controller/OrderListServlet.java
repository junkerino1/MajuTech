package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import model.Order;
import model.OrderItem;
import model.Product;
import service.OrderService;
import service.ProductService;

public class OrderListServlet extends HttpServlet {

    @Inject
    private OrderService orderService;

    @Inject
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Order> orders = orderService.getAllOrder();

        Map<Order, List<OrderItem>> orderItemMap = new HashMap<>();

        for (Order order : orders) {
            List<OrderItem> items = orderService.getOrderItemByOrder(order);
            orderItemMap.put(order, items);
        }

        request.setAttribute("orders", orders);
        request.setAttribute("orderItemMap", orderItemMap);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/order-list.jsp");
        dispatcher.forward(request, response);
    }

}
