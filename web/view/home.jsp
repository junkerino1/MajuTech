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

    <body>

        <section id="hero">
            <h4>Welcome To MajuTech</h4>
            <h2>Where Innovation</h2>
            <h1>Meets Your Lifestyle</h1>
            <h5>Always Low Price</h5>
            <button>Jom Shopping!</button>
        </section>


        <!-- ===================== -->
        <!--    Promotion Section  -->
        <!-- ===================== -->
        <div class="promotion-container">
            <div class="promotion-header">
                <% String campaignName = (String) request.getAttribute("campaignName"); %>
                <h1 class="promotion-title"><%=campaignName %></h1>
                <p class="promotion-subtitle">Limited Time Offers - Grab Yours Before They're Gone!</p>

                <div class="countdown-container">
                    <div class="countdown-item">
                        <div class="countdown-value" id="days">00</div>
                        <div class="countdown-label">Days</div>
                    </div>
                    <div class="countdown-item">
                        <div class="countdown-value" id="hours">00</div>
                        <div class="countdown-label">Hours</div>
                    </div>
                    <div class="countdown-item">
                        <div class="countdown-value" id="minutes">00</div>
                        <div class="countdown-label">Minutes</div>
                    </div>
                    <div class="countdown-item">
                        <div class="countdown-value" id="seconds">00</div>
                        <div class="countdown-label">Seconds</div>
                    </div>
                </div>
            </div>

            <div class="product-grid">
                <%
                    List<Product> promoProducts = (List<Product>) request.getAttribute("promoProducts");
                    if (promoProducts != null && !promoProducts.isEmpty()) {
                        for (Product product : promoProducts) {
                            if ("promotion".equalsIgnoreCase(product.getStatus())) {
                %>
                <div class="product-card">
                    <div>
                        <img src="<%= product.getImage1()%>" alt="<%= product.getProductName()%>" width="150px" height="150px">
                    </div>
                    <div class="product-details">
                        <h3 class="product-name"><%= product.getProductName()%></h3>
                        <div class="price-container">
                            <span class="original-price">RM <%= String.format("%.2f", product.getUnitPrice())%></span><br>
                            <span class="discounted-price">RM <%= String.format("%.2f", product.getEffectivePrice())%></span>
                            <%
                                double discountPercent = 100 - ((product.getEffectivePrice() / product.getUnitPrice()) * 100);
                            %>
                        </div>
                        <button class="buy-button" onclick="window.location.href = '${pageContext.request.contextPath}/product/<%= product.getId()%>';">Add to Cart</button>
                    </div>
                </div>
                <%
                        }
                    }
                } else {
                %>
                <p class="no-promo">No active promotions at this time</p>
                <% } %>
            </div>


        </div>

        <!-- ===================== -->
        <!--    Features Section   -->
        <!-- ===================== -->
        <div class="feature">
            <div class="fe-title">
                <h2>Why buy from MajuTech?</h2>
                <p>Your benefits!</p>
            </div>
            <section id="feature" class="section-p1">
                <div class="fe-box">
                    <img src="${pageContext.request.contextPath}/image/features/f1.png" alt="">
                    <h6>Free Shipping</h6>
                </div>
                <div class="fe-box">
                    <img src="${pageContext.request.contextPath}/image/features/f2.png" alt="">
                    <h6>Online Order</h6>
                </div>
                <div class="fe-box">
                    <img src="${pageContext.request.contextPath}/image/features/f3.png" alt="">
                    <h6>Save Money</h6>
                </div>
                <div class="fe-box">
                    <img src="${pageContext.request.contextPath}/image/features/f4.png" alt="">
                    <h6>Promotions</h6>
                </div>
                <div class="fe-box">
                    <img src="${pageContext.request.contextPath}/image/features/f5.png" alt="">
                    <h6>Happy Sell</h6>
                </div>
                <div class="fe-box">
                    <img src="${pageContext.request.contextPath}/image/features/f6.png" alt="">
                    <h6>F24/7 Support</h6>
                </div>
            </section>
            <!-- ===================== -->
            <!--    Products Section   -->
            <!-- ===================== -->
            <section id="product1" class="section-p1">
                <h2>Featured Products</h2>
                <p class="heading">Popular Right Now!</p>
                <%
                    List<Product> featuredProducts = (List<Product>) request.getAttribute("featuredProducts");
                %>
                <div class="pro-container">
                    <% if (featuredProducts != null) {
                            for (Product p : featuredProducts) {%>
                    <div class="pro" onclick="window.location.href = '${pageContext.request.contextPath}/product/<%= p.getId()%>';">
                        <img src="<%= p.getImage1()%>">
                        <div class="des">
                            <h5><%= p.getProductName()%></h5>
                            <% if ("promotion".equalsIgnoreCase(p.getStatus())) {%>
                            <h4>RM <%= String.format("%.2f", p.getEffectivePrice())%></h4>
                            <span class="original-price" style="text-decoration: line-through;">RM <%= String.format("%.2f", p.getUnitPrice())%></span>
                            <% } else {%>
                            <h4>RM <%= String.format("%.2f", p.getEffectivePrice())%></h4>
                            <% } %>
                            <a href="#"><i class="fa-solid fa-cart-shopping cart"></i></a>
                        </div>
                    </div>
                    <%  }
                        }%>
                </div>
            </section>
        </div>

        <!-- ===================== -->
        <!--    Products Section   -->
        <!-- ===================== -->
        <section id="banner" class="section-m1">
            <h4>Check Out More!</h4>
            <h2>Up to <span>50% off</span> - All Gadgets & Accessories</h2>
            <button class="normal" onclick="window.location.href = '${pageContext.request.contextPath}/product/'">Explore More</button>
        </section>



        <script src="${pageContext.request.contextPath}/script/clientscript.js"></script>

        <script>
                // Get the end date from server-side attribute
                const endDateStr = '${endDate}'; // This will be in format "yyyy-MM-dd"
                console.log("End date from server:", endDateStr);

                // Parse the end date (add time component to make it end of day)
                const countdownDate = new Date(endDateStr + 'T23:59:59');

                // Update the countdown every second
                const countdown = setInterval(function () {
                    const now = new Date().getTime();
                    const distance = countdownDate - now;

                    // Calculate days, hours, minutes and seconds
                    const days = Math.floor(distance / (1000 * 60 * 60 * 24));
                    const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                    const seconds = Math.floor((distance % (1000 * 60)) / 1000);

                    // Display the result
                    document.getElementById("days").innerHTML = days.toString().padStart(2, '0');
                    document.getElementById("hours").innerHTML = hours.toString().padStart(2, '0');
                    document.getElementById("minutes").innerHTML = minutes.toString().padStart(2, '0');
                    document.getElementById("seconds").innerHTML = seconds.toString().padStart(2, '0');

                    // If the countdown is finished
                    if (distance < 0) {
                        clearInterval(countdown);
                        document.querySelector(".promotion-subtitle").innerHTML = "Promotion Has Ended!";
                        document.querySelector(".buy-button").disabled = true;
                    }
                }, 1000);
        </script>
    </body>

    <jsp:include page="client-footer.jsp" />
</html>