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
            <h4>Trade-in-offer</h4>
            <h2>Super value deals</h2>
            <h1>On all products</h1>
            <p>Save more with coupons & up to 70% off!</p>
            <button>Shop Now</button>
        </section>


        <!-- ===================== -->
        <!--    Promotion Section  -->
        <!-- ===================== -->
        <div class="promotion-container">
            <div class="promotion-header">
                <h1 class="promotion-title">FLASH SALE</h1>
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
                <!-- Product 1 -->
                <div class="product-card">
                    <div class="product-image">
                        <img src="/api/placeholder/200/150" alt="Smart Watch">
                    </div>
                    <div class="product-details">
                        <h3 class="product-name">Smart Watch Pro</h3>
                        <div class="price-container">
                            <span class="original-price">$199.99</span>
                            <span class="discounted-price">$129.99</span>
                            <span class="discount-badge">-35%</span>
                        </div>
                        <button class="buy-button">Add to Cart</button>
                    </div>
                </div>

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
            <h2>Up to <span>70% off</span> - All T-shirts & Accessories</h2>
            <button class="normal" onclick="window.location.href = '${pageContext.request.contextPath}/product/'">Explore More</button>
        </section>



        <script src="${pageContext.request.contextPath}/script/clientscript.js"></script>
    </body>

    <jsp:include page="client-footer.jsp" />
</html>