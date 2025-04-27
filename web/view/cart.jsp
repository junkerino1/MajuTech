<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.Product" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <script src="https://kit.fontawesome.com/bcb2c05d90.js" crossorigin="anonymous"></script>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MajuTech</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            .main-content {
                flex: 1;
                max-width: 1200px;
                width: 100%;
                margin: 0 auto;
                padding: 40px 24px;
            }

            .page-title {
                font-size: 28px;
                color: #1e293b;
                margin-bottom: 24px;
                padding-bottom: 16px;
                border-bottom: 1px solid #e2e8f0;
            }

            .empty-cart {
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                padding: 60px 40px;
                text-align: center;
                margin: 20px 0 40px;
            }

            .cart-icon {
                width: 100px;
                height: 100px;
                background-color: #f0f7ff;
                border-radius: 50%;
                display: flex;
                justify-content: center;
                align-items: center;
                margin: 0 auto 32px;
            }

            .cart-icon svg {
                width: 50px;
                height: 50px;
                color: #088178;
            }

            .empty-cart h2 {
                font-size: 28px;
                color: #1e293b;
                margin-bottom: 16px;
            }

            .empty-cart p {
                font-size: 18px;
                color: #64748b;
                margin-bottom: 32px;
                line-height: 1.6;
                max-width: 500px;
                margin-left: auto;
                margin-right: auto;
            }

            .shop-button {
                background-color: #088178;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 14px 32px;
                font-size: 18px;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.2s ease;
            }


            @media (max-width: 768px) {
                .nav-menu {
                    display: none;
                }

                .empty-cart {
                    padding: 40px 20px;
                }

                .product-grid {
                    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                }
            }
        </style>

    </head>

    <body>

        <jsp:include page="client-navbar.jsp" />

        <section id="cart" class="section-p1">

            <div class="main-content">
                <h1 class="page-title">Your Shopping Cart</h1>
                <%
                    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                    List<Product> productsInCart = (List<Product>) request.getAttribute("productsInCart");
                    if (!cartItems.isEmpty()) {

                %>
                <table width="100%">
                    <thead>
                        <tr>
                            <td>Remove</td>
                            <td>Image</td>
                            <td>Product</td>
                            <td>Price</td>
                            <td>Quantity</td>
                            <td>Subtotal</td>
                        </tr>
                    </thead>
                    <%                    double total = 0.0;
                        double totalDiscount = 0.0;

                        if (cartItems != null && productsInCart != null && cartItems.size() == productsInCart.size()) {
                            for (int i = 0; i < cartItems.size(); i++) {
                                CartItem item = cartItems.get(i);
                                Product product = productsInCart.get(i);

                                double subtotal = product.getEffectivePrice() * item.getQuantity();
                                total += subtotal;
                    %>
                    <tbody>

                        <tr>
                            <td>
                                <a href="<%= request.getContextPath()%>/remove-from-cart/<%= item.getId()%>">
                                    <i class="far fa-times-circle"></i>
                                </a>
                            </td>
                            <td><img src="<%= product.getImage1()%>" width="80" height="80" /></td>
                            <td style="max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"><%= product.getProductName()%></td>
                            <td>

                                <% if ("promotion".equalsIgnoreCase(product.getStatus())) {
                                        double discount = product.getUnitPrice() - product.getEffectivePrice();
                                        totalDiscount += discount;
                                %>
                                <h4  style="color: red;">RM <%= String.format("%.2f", product.getEffectivePrice())%></h4>
                                <span class="original-price" style="text-decoration: line-through;">RM <%= String.format("%.2f", product.getUnitPrice())%></span>
                                <% } else {%>
                                RM <%= String.format("%.2f", product.getEffectivePrice())%>
                                <% }%>
                            </td>
                            <td><%= item.getQuantity()%></td>
                            <td>RM <%= String.format("%.2f", subtotal)%></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
        </section>

        <%
            double shipping = total > 1000 ? 0.00 : 25.00;
            double grandTotal = total + shipping;

        %>


        <section id="cart-add" class="section-p1">
            <div id="subtotal">
                <h3>Cart Totals</h3>
                <table>
                    <tr>
                        <td>Cart Subtotal</td>
                        <td>RM <%= String.format("%.2f", total)%></td>
                    </tr>
                    <tr>
                        <td>Total Saved</td>
                        <td>RM <%= String.format("%.2f", totalDiscount)%></td>
                    </tr>
                    <tr>
                        <td>Shipping</td>
                        <td>RM <%= String.format("%.2f", shipping)%></td>
                    </tr>
                    <tr>
                        <td><strong>Total</strong></td>
                        <td><strong>RM <%= String.format("%.2f", grandTotal)%></strong></td>
                    </tr>
                </table>

                <% if (shipping == 0.0) { %>
                <p style="color: green; font-weight: bold;">🎉 Congratulations! You’ve unlocked free shipping!</p>
                <% } %>

                <%
                    int cartId = (Integer) request.getAttribute("cartId");
                %>

                <a href="${pageContext.request.contextPath}/checkout/<%= cartId%>">
                    <button class="normal">Proceed to checkout</button>
                </a>  
            </div>
            <%
                }
            } else {
            %>



            <div class="empty-cart">
                <div class="cart-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                    </svg>
                </div>
                <h2>Your cart is empty</h2>
                <p>It looks like you haven't added any items to your cart yet. Browse our collection and discover amazing products that you'll love.</p>
                <a href="<%= request.getContextPath()%>/product" class="shop-button">Start Shopping</a>
            </div>


            <% }%>

        </section>




        <jsp:include page="client-footer.jsp" />

    </body>
</html>
