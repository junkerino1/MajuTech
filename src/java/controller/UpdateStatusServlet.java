package controller;

import jakarta.annotation.Resource;
import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.transaction.UserTransaction;

import java.io.IOException;
import java.io.PrintWriter;
import model.Order;
import service.OrderService;

public class UpdateStatusServlet extends HttpServlet {
    
    @Inject
    private OrderService orderService;
    
    @Resource
    private UserTransaction utx;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");
        
        try {
            
            Order order = orderService.getOrderById(orderId);
            order.setStatus(status);
            
            utx.begin();
            orderService.updateOrder(order);
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
}
