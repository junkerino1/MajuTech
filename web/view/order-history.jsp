<%@page import="model.Product"%>
<%@page import="model.ShippingAddress"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="model.Order"%>
<%@page import="model.OrderItem"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order History</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order-history.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>

        <jsp:include page="client-navbar.jsp"/>

        <div class="container">
            <div class="page-header">
                <h1>Order History</h1>
                <div class="filter-controls">
                    <div class="search-box">
                        <input type="text" placeholder="Search by order number, product name...">
                    </div>
                    <select class="filter-dropdown">
                        <option value="all">All Orders</option>
                        <option value="delivered">Delivered</option>
                        <option value="processing">Processing</option>
                        <option value="shipped">Shipped</option>
                    </select>
                </div>
            </div>

            <%
                Map<Order, List<OrderItem>> orderMap = (Map<Order, List<OrderItem>>) request.getAttribute("orderMap");
            %>


            <div class="order-list">
                <% for (Map.Entry<Order, List<OrderItem>> entry : orderMap.entrySet()) {
                        Order order = entry.getKey();
                        List<OrderItem> items = entry.getValue();
                        ShippingAddress address = order.getShippingAddress();
                %>

                <!-- Order 2 - Delivered with Rating Form -->
                <div class="order-card">
                    <div class="order-header">
                        <div>
                            <span class="order-id">Order #<%= order.getOrderId()%></span>

                            <% if ("Delivered".equalsIgnoreCase(order.getStatus())) { %>
                            <span class="order-status status-delivered">Delivered</span>
                            <% } else if ("Processing".equalsIgnoreCase(order.getStatus())) { %>
                            <span class="order-status status-processing">Processing</span>
                            <% } %>
                        </div>

                        <%
                            java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("MMMM dd, yyyy");
                            String orderDate = order.getDate().format(formatter);
                        %>
                        <span class="order-date"><%= orderDate%></span>
                    </div>

                    <div class="order-content">
                        <div class="product-list">
                            <% for (OrderItem item : items) {
                                    Product p = item.getProduct();
                            %>
                            <div class="product-item">
                                <div class="product-image">
                                    <img src="<%= p.getImage1()%>" alt="<%= p.getProductName()%>" />
                                </div>
                                <div class="product-details">
                                    <div class="product-name"><%= p.getProductName()%></div>
                                    <div class="product-meta">Quantity: <%= item.getQuantity()%></div>
                                    <div class="product-price">RM <%= String.format("%.2f", item.getCurrentPrice()) %></div>
                                </div>
                            </div>
                            <% }%>
                        </div>

                        <div class="order-summary">
                            <div class="order-address">
                                <div class="address-title">Shipping Address</div>
                                <div class="address-content">
                                    <%= address.getName()%><br>
                                    <%= address.getStreet1()%><br>
                                    <%= address.getStreet2()%><br>
                                    <%= address.getState()%>, <%= address.getPostcode()%><br>
                                    Phone: <%= address.getPhoneNumber()%>
                                </div>
                            </div>
                            <div class="order-totals">
                                <div class="total-row">
                                    <div class="total-label">Total</div>
                                    <div class="total-value">RM <%= String.format("%.2f", order.getTotalAmount()) %></div>
                                </div>
                            </div>
                        </div>

                        <%-- Optional rating section --%>
                        <% if ("Delivered".equalsIgnoreCase(order.getStatus())) { %>
                        <div class="rating-section">
                            <div class="rating-title">
                                Product Review
                                <span class="rating-status">Pending your review</span>
                            </div>
                            <div class="rating-form">
                                <div class="stars-container">
                                    <% for (int i = 0; i < 5; i++) { %>
                                    <svg class="star" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                                    </svg>
                                    <% } %>
                                </div>
                                <textarea placeholder="Share your thoughts about this product..."></textarea>
                                <button type="button">Submit Review</button>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% }%>
            </div>
        </div>
    </body>

    <jsp:include page="client-footer.jsp"/>
</html>
