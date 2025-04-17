<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Product" %>
<!DOCTYPE html>
<html lang="en">

    <jsp:include page="client-navbar.jsp" />

    <head>
        <script src="https://kit.fontawesome.com/bcb2c05d90.js" crossorigin="anonymous"></script>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MajuTech</title>
        <!-- Font Awesome Library -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>


    <!-- ===================== -->
    <!--    P-Header Section   -->
    <!-- ===================== -->
    <section id="page-header" class="about-header">
        <h2>#let's_talk</h2>

        <p> leave a messege , we love to hear from you! </p>
    </section>

    <!-- ===================== -->
    <!---     cart details    --->
    <!-- ===================== --> 
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
            <tbody>

            </tbody>
        </table>
    </section>

    <section id="cart-add" class="section-p1">
        <div id="subtotal">
            <h3>Cart Totals</h3>
            <table>
                <tr>
                    <td>Cart Subtotal</td>
                    <td>600 EGP</td>
                </tr>
                <tr>
                    <td>Shipping</td>
                    <td>50 EGP</td>
                </tr>
                <tr>
                    <td><strong>Total</strong></td>
                    <td><strong>650 EGP</strong></td>
                </tr>
            </table>
            <a href="payment-gateway.html">
                <button class="normal">Proceed to checkout</button>
            </a>  
        </div>
    </section>
    
    <jsp:include page="client-footer.jsp" />