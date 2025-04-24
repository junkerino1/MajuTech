package controller;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import service.OrderService;
import service.ProductService;
import jakarta.json.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Order;
import model.OrderItem;
import org.json.*;

public class SalesDetailServlet extends HttpServlet {

    @Inject
    private OrderService orderService;

    @Inject
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dateParam = request.getParameter("date");
        LocalDate date = LocalDate.parse(dateParam);

        List<Order> dailyOrder = orderService.getOrderByDate(date);

        int dailyOrderCount = 0;
        int dailyItemSold = 0;
        double dailyRevenue = 0.0;
        double dailyDiscount = 0.0;

        // Maps to hold hourly data
        Map<Integer, Double> salesByHour = new LinkedHashMap<>();
        Map<Integer, Integer> ordersByHour = new LinkedHashMap<>();

        // Initialize sales and orders for each hour
        for (int hour = 0; hour <= 24; hour++) {
            salesByHour.put(hour, 0.0);
            ordersByHour.put(hour, 0);
        }

        // To store product purchased list
        List<Map<String, Object>> productList = new ArrayList<>();

        for (Order order : dailyOrder) {
            dailyOrderCount++;
            dailyRevenue += order.getTotalAmount();
            List<OrderItem> items = orderService.getOrderItemByOrder(order);
            LocalDateTime dailyDate = order.getDate();
            int hour = dailyDate.getHour();

            // Count sales
            double currentSales = salesByHour.get(hour);
            salesByHour.put(hour, (currentSales + order.getTotalAmount()) / 1000);

            // Count order
            int currentOrders = ordersByHour.get(hour);
            ordersByHour.put(hour, currentOrders + 1);

            for (OrderItem item : items) {
                // Customize product data to add to product list
                Map<String, Object> productMap = new HashMap<>();
                productMap.put("id", item.getProduct().getId());
                productMap.put("name", item.getProduct().getProductName());
                productMap.put("category", productService.getCategoryNameById(item.getProduct().getCategoryId()));
                productMap.put("quantity", item.getQuantity());
                productMap.put("unitPrice", item.getProduct().getUnitPrice());
                productMap.put("discount", item.getProduct().getUnitPrice() - item.getCurrentPrice());
                productMap.put("total", item.getQuantity() * item.getCurrentPrice());

                dailyItemSold += item.getQuantity();
                dailyDiscount += (item.getProduct().getUnitPrice() - item.getCurrentPrice());

                // Check if product already exists in the list
                boolean found = false;
                for (Map<String, Object> existing : productList) {
                    if (existing.get("id").equals(productMap.get("id"))) {
                        int existingQty = (int) existing.get("quantity");
                        existing.put("quantity", existingQty + item.getQuantity());

                        double existingTotal = (double) existing.get("total");
                        existing.put("total", existingTotal + (item.getQuantity() * item.getCurrentPrice()));

                        found = true;
                        break;
                    }
                }

                if (!found) {
                    productList.add(new HashMap<>(productMap)); // add a copy to avoid overwriting
                }
            }
        }

        StringBuilder productJson = new StringBuilder();
        productJson.append("[");

        for (int i = 0; i < productList.size(); i++) {
            Map<String, Object> prod = productList.get(i);

            // Use double quotes for proper JSON syntax
            productJson.append("{ ");
            productJson.append("\"id\": ").append(prod.get("id")).append(", ");
            productJson.append("\"name\": \"").append(prod.get("name")).append("\", ");
            productJson.append("\"category\": \"").append(prod.get("category")).append("\", ");
            productJson.append("\"quantity\": ").append(prod.get("quantity")).append(", ");
            productJson.append("\"unitPrice\": ").append(prod.get("unitPrice")).append(", ");
            productJson.append("\"discount\": ").append(prod.get("discount")).append(", ");
            productJson.append("\"total\": ").append(prod.get("total"));
            productJson.append(" }");

            if (i < productList.size() - 1) {
                productJson.append(", ");
            }
        }

        productJson.append("]");
        System.out.println(productJson.toString());
        request.setAttribute("productListJson", productJson.toString());

        JSONArray hours = new JSONArray();
        JSONArray sales = new JSONArray();
        JSONArray orders = new JSONArray();

        for (int i = 0; i <= 24; i++) {
            String label = String.format("%02d:00", i); // e.g., "00:00", "01:00", etc.
            hours.put(label);
            sales.put(salesByHour.getOrDefault(i, 0.0));
            orders.put(ordersByHour.getOrDefault(i, 0));
        }

        request.setAttribute("hours", hours.toString());
        request.setAttribute("sales", sales.toString());
        request.setAttribute("orders", orders.toString());
        request.setAttribute("productMap", productList);
        request.setAttribute("dailyOrderCount", dailyOrderCount);
        request.setAttribute("dailyItemSold", dailyItemSold);
        request.setAttribute("dailyRevenue", dailyRevenue);
        request.setAttribute("dailyDiscount", dailyDiscount);
        request.setAttribute("dateParam", dateParam);

        request.getRequestDispatcher("/view/sales-details.jsp").forward(request, response);
    }

}
