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
    </head>

    <body>

        <jsp:include page="client-navbar.jsp" />



        <section id="cart" class="section-p1">
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
                <%
                    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                    double total = 0.0;
                    if (cartItems != null && !cartItems.isEmpty()) {

                        for (CartItem item : cartItems) {
                            Product product = item.getProduct();
                            double subtotal = product.getUnitPrice() * item.getQuantity();
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
                        <td><%= product.getProductName()%></td>
                        <td>RM <%= String.format("%.2f", product.getUnitPrice())%></td>
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
            double shipping = total > 1000 ? 0.00 : 10.00;
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
            %>
        </section>



        <jsp:include page="client-footer.jsp" />

    </body>
</html>
