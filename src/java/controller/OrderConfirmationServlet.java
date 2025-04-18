/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;


import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import service.CartService;

import java.io.IOException;
import java.util.List;
import model.Order;
import model.OrderItem;
import model.ShippingAddress;
import service.OrderService;
/**
 *z
 * @author junky
 */
public class OrderConfirmationServlet extends HttpServlet {
    
    @Inject
    private OrderService orderService;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters from URL
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        Order order = orderService.getOrderById(orderId);   
        List<OrderItem> orderItems = orderService.getOrderItemByOrder(order);
        ShippingAddress address = order.getShippingAddress();
        
        // Pass data to JSP
        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("address", address);
        request.getRequestDispatcher("/view/order-confirmation.jsp").forward(request, response);
    }
}
