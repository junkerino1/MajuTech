package controller;

import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import service.OrderService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import model.Order;
import model.OrderItem;

public class DashboardServlet extends HttpServlet {


    @Inject
    private OrderService orderService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int totalOrders = 0;
        int totalQuantity = 0;
        double totalSales = 0.0;
        double totalDiscount = 0.0;

        int delivered = 0;
        int shipped = 0;
        int processing = 0;

        List<Order> orders = orderService.getAllOrder();

        for (Order order : orders) {
            totalOrders++;
            totalSales += order.getTotalAmount();
            List<OrderItem> items = orderService.getOrderItemByOrder(order);

            String status = order.getStatus();
            switch (status.toLowerCase()) {
                case "delivered" -> delivered++;
                case "shipped" -> shipped++;
                case "processing" -> processing++;
            }

            for (OrderItem item : items) {
                totalQuantity += item.getQuantity();
                double discount = item.getProduct().getUnitPrice() - item.getCurrentPrice();
                totalDiscount += discount * item.getQuantity();
            }
        }

        List<Integer> orderStats = new ArrayList<>();
        orderStats.add(delivered);
        orderStats.add(shipped);
        orderStats.add(processing);

        List<Double> dailySales = new ArrayList<>();

        // Get last 7 days sales (oldest to newest)
        for (int i = 6; i >= 0; i--) {
            LocalDate date = LocalDate.now().minusDays(i);
            List<Order> dailyOrders = orderService.getOrderByDate(date);

            double dailyTotal = 0.0;
            for (Order order : dailyOrders) {
                dailyTotal += order.getTotalAmount();
            }

            dailySales.add(dailyTotal);
        }
        
        List<Order> recentTransaction = orderService.getAllOrderDesc();

        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalSales", totalSales);
        request.setAttribute("totalQuantity", totalQuantity);
        request.setAttribute("totalDiscount", totalDiscount);
        request.setAttribute("recentTransaction", recentTransaction);

        request.setAttribute("orderStats", orderStats);
        request.setAttribute("dailySales", dailySales);

        request.getRequestDispatcher("/view/dashboard.jsp").forward(request, response);
    }
}
