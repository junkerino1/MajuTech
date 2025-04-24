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

public class SalesServlet extends HttpServlet {

    @Inject
    private OrderService orderService;

    @Inject
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int month = LocalDate.now().getMonthValue();
        System.out.println("month:" + month);

        List<Map<String, Object>> monthlyComparison = new ArrayList<>();

        // get monthly metrics
        int cmTotalOrders = 0;
        int cmTotalQuantity = 0;
        double cmTotalSales = 0.0;
        double cmTotalDiscount = 0.0;

        List<Order> cmOrder = orderService.getOrderByMonth(2025, month);

        for (Order order : cmOrder) {
            cmTotalOrders++;
            cmTotalSales += order.getTotalAmount();
            List<OrderItem> items = orderService.getOrderItemByOrder(order);
            for (OrderItem item : items) {
                cmTotalQuantity += item.getQuantity();
                double discount = item.getProduct().getUnitPrice() - item.getCurrentPrice();
                cmTotalDiscount += discount;
            }
        }

        // get monthly metrics
        int pmTotalOrders = 0;
        int pmTotalQuantity = 0;
        double pmTotalSales = 0.0;
        double pmTotalDiscount = 0.0;

        List<Order> pmOrder = orderService.getOrderByMonth(2025, month - 1);

        for (Order order : pmOrder) {
            pmTotalOrders++;
            pmTotalSales += order.getTotalAmount();
            List<OrderItem> items = orderService.getOrderItemByOrder(order);
            for (OrderItem item : items) {
                pmTotalQuantity += item.getQuantity();
                double discount = item.getProduct().getUnitPrice() - item.getCurrentPrice();
                pmTotalDiscount += discount;
            }
        }

        // Current month data
        Map<String, Object> cmData = new HashMap<>();

        cmData.put("sales", cmTotalSales);
        cmData.put("orders", cmTotalOrders);
        cmData.put("quantity", cmTotalQuantity);
        cmData.put("discount", cmTotalDiscount);

        // Previous month data
        Map<String, Object> pmData = new HashMap<>();
        pmData.put("sales", pmTotalSales);
        pmData.put("orders", pmTotalOrders);
        pmData.put("quantity", pmTotalQuantity);
        pmData.put("discount", pmTotalDiscount);

        monthlyComparison.add(cmData);
        monthlyComparison.add(pmData);

        Map<String, JsonObject> salesDataMap = new HashMap<>();
        List<Map<LocalDate, Object[]>> dailySalesList = new ArrayList<>();

        // Loop 1 week (7 days)
        for (int i = 0; i < 7; i++) {
            LocalDate date = LocalDate.now().minusDays(i);
            List<Order> dailyOrder = orderService.getOrderByDate(date);

            LocalDate currentDate = date;

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

                double currentSales = salesByHour.get(hour);
                salesByHour.put(hour, currentSales + order.getTotalAmount());

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

            // store daily sales data
            Map<LocalDate, Object[]> dailyData = new HashMap<>();
            dailyData.put(currentDate, new Object[]{
                dailyOrderCount,
                dailyItemSold,
                dailyRevenue,
                dailyDiscount
            });
            dailySalesList.add(dailyData);

            // Prepare hourly data for the JSON
            JsonArrayBuilder hoursArray = Json.createArrayBuilder();
            JsonArrayBuilder salesArray = Json.createArrayBuilder();
            JsonArrayBuilder ordersArray = Json.createArrayBuilder();

            for (int hour = 0; hour <= 24; hour++) {
                hoursArray.add(String.format("%02d:00", hour));
                salesArray.add(salesByHour.get(hour));
                ordersArray.add(ordersByHour.get(hour));
            }

            JsonObject hourlyData = Json.createObjectBuilder()
                    .add("hours", hoursArray)
                    .add("sales", salesArray)
                    .add("orders", ordersArray)
                    .build();

            // Create JSON object for this day's data
            JsonArrayBuilder productArray = Json.createArrayBuilder();
            for (Map<String, Object> prod : productList) {
                productArray.add(Json.createObjectBuilder()
                        .add("id", prod.get("id").toString())
                        .add("name", prod.get("name").toString())
                        .add("category", prod.get("category").toString())
                        .add("quantity", (int) prod.get("quantity"))
                        .add("unitPrice", (double) prod.get("unitPrice"))
                        .add("discount", (double) prod.get("discount"))
                        .add("total", (double) prod.get("total"))
                );
            }

            JsonObject dailySales = Json.createObjectBuilder()
                    .add("totalRevenue", dailyRevenue)
                    .add("ordersCount", dailyOrderCount)
                    .add("itemsSold", dailyItemSold)
                    .add("totalDiscount", dailyDiscount)
                    .add("products", productArray)
                    .add("hourlyData", hourlyData)
                    .build();

            // Add daily sales data to the final salesData map with date as key
            salesDataMap.put(date.toString(), dailySales);
        }

        // Convert the final sales data map to the format you want (in JSON form)
        JsonObjectBuilder finalJsonBuilder = Json.createObjectBuilder();
        for (Map.Entry<String, JsonObject> entry : salesDataMap.entrySet()) {
            finalJsonBuilder.add(entry.getKey(), entry.getValue());
        }

        // Get the final JSON as a string if needed
        JsonObject finalJson = finalJsonBuilder.build();
        
        request.setAttribute("monthly", monthlyComparison);
        request.setAttribute("daily", dailySalesList);
        request.setAttribute("salesData", finalJson);
        request.getRequestDispatcher("/view/sales.jsp").forward(request, response);

    }
    
}
