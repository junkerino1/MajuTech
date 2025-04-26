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
        
        List<Map<LocalDate, Object[]>> dailySalesList = getDailyReport();
        List<Map<String, Object[]>> monthlySalesList = getMonthlyReport();
        
        request.setAttribute("monthlyComparison", monthlyComparison);
        request.setAttribute("dailyReport", dailySalesList);
        request.setAttribute("monthlyReport", monthlySalesList);
        request.getRequestDispatcher("/view/sales.jsp").forward(request, response);

    }

    public List<Map<LocalDate, Object[]>> getDailyReport() {
        Map<String, JsonObject> salesDataMap = new HashMap<>();
        List<Map<LocalDate, Object[]>> dailySalesList = new ArrayList<>();

        for (int i = 0; i < 7; i++) {
            LocalDate date = LocalDate.now().minusDays(i);
            List<Order> dailyOrder = orderService.getOrderByDate(date);

            LocalDate currentDate = date;

            int dailyOrderCount = 0;
            int dailyItemSold = 0;
            double dailyRevenue = 0.0;
            double dailyDiscount = 0.0;

            for (Order order : dailyOrder) {
                dailyOrderCount++;
                dailyRevenue += order.getTotalAmount();
                List<OrderItem> items = orderService.getOrderItemByOrder(order);

                for (OrderItem item : items) {
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
                }
            }

            Map<LocalDate, Object[]> dailyData = new HashMap<>();
            dailyData.put(currentDate, new Object[]{
                dailyOrderCount,
                dailyItemSold,
                dailyRevenue,
                dailyDiscount
            });
            dailySalesList.add(dailyData);
        }
        
        return dailySalesList;
    }

    public List<Map<String, Object[]>> getMonthlyReport() {
        Map<String, JsonObject> salesDataMap = new HashMap<>();
        List<Map<String, Object[]>> monthlySalesList = new ArrayList<>();

        for (int month = 1; month <= 12; month++) {
            LocalDate monthStart = LocalDate.of(LocalDate.now().getYear(), month, 1);
            LocalDate monthEnd = monthStart.withDayOfMonth(monthStart.lengthOfMonth());

            List<Order> monthlyOrders = orderService.getOrderByMonth(2025, month);

            int monthlyOrderCount = 0;
            int monthlyItemSold = 0;
            double monthlyRevenue = 0.0;
            double monthlyDiscount = 0.0;

            for (Order order : monthlyOrders) {
                monthlyOrderCount++;
                monthlyRevenue += order.getTotalAmount();
                List<OrderItem> items = orderService.getOrderItemByOrder(order);

                for (OrderItem item : items) {
                    monthlyItemSold += item.getQuantity();
                    monthlyDiscount += (item.getProduct().getUnitPrice() - item.getCurrentPrice()) * item.getQuantity();
                }
            }

            Map<String, Object[]> monthlyData = new HashMap<>();
            monthlyData.put(monthStart.getMonth().name(), new Object[]{
                monthlyOrderCount,
                monthlyItemSold,
                monthlyRevenue,
                monthlyDiscount
            });

            monthlySalesList.add(monthlyData);
        }
        
        return monthlySalesList;
    }

}
