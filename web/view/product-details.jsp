<%@page import="model.Review"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Product" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>

    <jsp:include page="client-navbar.jsp"/>

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

        <%
            Product product = (Product) request.getAttribute("product");
            double rating = (double) request.getAttribute("rating");
            int counter = (int) request.getAttribute("counter");
            List<Review> reviews = (List<Review>) request.getAttribute("reviews");
        %>

        <section id="prodetails" class="section-p1">
            <div class="single-pro-image">
                <img src="<%= product.getImage1()%>" width="100%" id="MainImg" alt="" />

                <div class="small-img-group">
                    <div class="small-img-col">
                        <img src="<%= product.getImage1()%>" width="100%" class="small-img" alt="" />
                    </div>
                    <div class="small-img-col">
                        <img src="<%= product.getImage2()%>" width="100%" class="small-img" alt="" />
                    </div>
                    <div class="small-img-col">
                        <img src="<%= product.getImage3()%>" width="100%" class="small-img" alt="" />
                    </div>
                    <div class="small-img-col">
                        <img src="<%= product.getImage4()%>" width="100%" class="small-img" alt="" />
                    </div>
                </div>
            </div>

            <div class="single-pro-details">
                <h1><%= product.getProductName()%></h1>
                <div class="star-rating">
                    <%
                        for (int i = 1; i <= 5; i++) {
                            if (i <= (int) rating) {
                    %>
                    <i class="fa-solid fa-star"></i> <%-- Filled star --%>
                    <%
                    } else {
                    %>
                    <i class="fa-solid fa-star empty"></i> <%-- Empty star --%>
                    <%
                            }
                        }
                    %> 

                    (<%= counter%>)
                </div>

                <% if ("promotion".equalsIgnoreCase(product.getStatus())) {%>
                <h2>RM <%= String.format("%.2f", product.getEffectivePrice())%></h2>
                <span class="original-price" style="text-decoration: line-through;">RM <%= String.format("%.2f", product.getUnitPrice())%></span>
                <% } else {%>
                <h2>RM <%= String.format("%.2f", product.getEffectivePrice())%></h2>
                <% }%>
                <ul style="font-weight: bold;list-style-type: disc;padding-left: 20px;">
                    <%= product.getSpecification()%>
                </ul>

                <form action="${pageContext.request.contextPath}/add-to-cart" method="post">
                    <input type="hidden" name="productId" value="<%= product.getId()%>" />
                    <input type="number" name="quantity" value="1" />
                    <button class="normal">Add To cart</button>
                </form>

            </div>
        </section>

        <section id="prodetails" class="section-p1">
            <div>
                <h4>Product Details</h4><br>
                <%= product.getDescription()%>
            </div>
        </section>
        <script>
            var MainImg = document.getElementById("MainImg");
            var smallimg = document.getElementsByClassName("small-img");

            smallimg[0].onclick = function () {
                MainImg.src = smallimg[0].src;
            };
            smallimg[1].onclick = function () {
                MainImg.src = smallimg[1].src;
            };

            smallimg[2].onclick = function () {
                MainImg.src = smallimg[2].src;
            };

            smallimg[3].onclick = function () {
                MainImg.src = smallimg[3].src;
            };
        </script>

        <section class="section-p1">
            <h2>Reviews</h2>
            <div class="reviews-list">
                <%
                    for (Review review : reviews) {
                %>
                <div class="review-container">
                    <div class="review-header">
                        <div class="user-info">
                            <span class="username"><%= review.getUsername()%></span>
                        </div>
                    </div>

                    <div class="star-rating">

                        <%
                            int stars = (int) review.getRating();
                            for (int i = 1; i <= 5; i++) {
                                if (i <= stars) {
                        %>
                        <i class="fa-solid fa-star"></i> <%-- Filled star --%>
                        <%
                        } else {
                        %>
                        <i class="fa-solid fa-star empty"></i> <%-- Empty star --%>
                        <%
                                }
                            }
                        %>
                    </div>

                    <div class="review-comment">
                        <%= review.getComment()%>
                    </div>
                </div>
                <% } %>
            </div>


        </section>

        <section id="product1" class="section-p1">
            <h2>You May Also Like:</h2>
            <p class="heading">Yeah So We Can Earn Your Money!</p>
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
    </body>
    <jsp:include page="client-footer.jsp"/>
    <script src="${pageContext.request.contextPath}/script/script.js"></script>
</html>