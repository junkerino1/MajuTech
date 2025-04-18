<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="model.Order"%>
<%@page import="model.OrderItem"%>
<%@ page import="model.ShippingAddress" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@page import="java.time.LocalDateTime"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order-confirmation.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
        <title>Order Confirmation</title>
    </head>

    <jsp:include page="client-navbar.jsp" />
    
    <body>

        <div class="container">
            <div class="success-header">
                <div class="success-icon">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/>
                    </svg>
                </div>
                <h1>Payment Successful!</h1>
                <p>Your order has been placed and will be processed shortly.</p>
            </div>

            <%
                Order order = (Order) request.getAttribute("order");
                List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
                ShippingAddress address = (ShippingAddress) request.getAttribute("address");

                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy | hh:mm a");
                DateTimeFormatter dateonly = DateTimeFormatter.ofPattern("MMMM dd, yyyy");
                String formattedDate = ((java.time.LocalDateTime) order.getDate()).format(formatter);
            %>

            <div class="order-details">
                <h2>Order Details</h2>
                <div class="detail-row">
                    <div class="detail-label">Order Number</div>
                    <div class="detail-value">#ORD<%= order.getOrderId()%></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Date</div>
                    <div class="detail-value"><%= formattedDate%></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Payment Method</div>
                    <div class="detail-value"><%= order.getPaymentMethod()%></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Total Amount</div>
                    <div class="detail-value">RM <%= String.format("%.2f", order.getTotalAmount())%></div>
                </div>
            </div>

            <div class="products-container">
                <h2>Products</h2>
                <% for (OrderItem item : orderItems) {%>
                <div class="product-item">
                    <div class="product-image">
                        <img src="<%= item.getProduct().getImage1()%>" alt="Product Image" />
                    </div>
                    <div class="product-details">
                        <div class="product-name"><%= item.getProduct().getProductName()%></div>
                        <div class="product-price">RM <%= String.format("%.2f", item.getCurrentPrice())%></div>
                        <div class="product-meta">
                            <div>Quantity: <%= item.getQuantity()%></div>
                        </div>
                    </div>
                </div>
                <% }%>
            </div>

            <div class="shipping-details">
                <h2>Shipping Information</h2>
                <div class="shipping-address">
                    <strong><%= address.getName()%></strong><br>
                    <%= address.getStreet1()%>, <%= address.getStreet2()%><br>
                    <%= address.getState()%> <%= address.getPostcode()%><br>
                    Phone: <%= address.getPhoneNumber()%>
                </div>

                <%
                    LocalDateTime orderDate = (LocalDateTime) order.getDate();
                    LocalDateTime estimatedShipped = orderDate.plusDays(1);
                    LocalDateTime estimatedDelivery = orderDate.plusDays(3);
                    String formattedDelivery = estimatedDelivery.format(dateonly);
                    String formattedShipped = estimatedShipped.format(dateonly);
                    String formattedProcessing = orderDate.format(dateonly);
                %>

                <div class="shipping-method">
                    <div class="shipping-icon">
                        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M20 8h-3V4H3c-1.1 0-2 .9-2 2v11h2c0 1.66 1.34 3 3 3s3-1.34 3-3h6c0 1.66 1.34 3 3 3s3-1.34 3-3h2v-5l-3-4zM6 18.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm13.5-9l1.96 2.5H17V9.5h2.5zm-1.5 9c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z"/>
                        </svg>
                    </div>
                    <div>
                        <strong>Express Shipping</strong><br>
                        Estimated delivery: <%= formattedDelivery%>
                    </div>
                </div>
                <div class="shipping-timeline">
                    <div class="timeline-title">Order Status</div>
                    <div class="timeline-steps">
                        <div class="timeline-step completed">
                            <div>Order Confirmed</div>
                            <div class="step-time"><%= formattedProcessing%></div>
                        </div>
                        <div class="timeline-step pending">
                            <div>Shipped</div>
                            <div class="step-time">Estimated: <%= formattedShipped%></div>
                        </div>
                        <div class="timeline-step pending">
                            <div>Delivered</div>
                            <div class="step-time">Estimated: <%= formattedDelivery%></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/order">
                    <div class="action-button primary-action">Track Order</div>
                </a>
                <a href="${pageContext.request.contextPath}/product">
                    <div class="action-button secondary-action">Continue Shopping</div>
                </a>  
            </div>
        </div>
    </body>

    <jsp:include page="client-footer.jsp" />
</html>
