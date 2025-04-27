<%@page import="model.Reply"%>
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
        <link rel="icon" type="image" href="${pageContext.request.contextPath}/image/logo.png">
        <title>MajuTech - Product Details</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .out-of-stock {
                background-color: #f8d7da;
                border: 1px solid #f5c6cb;
                border-radius: 4px;
                padding: 15px;
                margin-top: 10px;
            }

            .out-of-stock-badge {
                display: inline-block;
                background-color: #dc3545;
                color: white;
                padding: 5px 10px;
                border-radius: 4px;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .stock-info {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }

            .stock-status {
                margin-left: 8px;
                font-weight: 500;
            }

            .in-stock {
                color: #28a745;
            }

            .low-stock {
                color: #ffc107;
            }

            .sold-out {
                color: #dc3545;
            }

            .disabled-btn {
                background-color: #cccccc !important;
                cursor: not-allowed;
                opacity: 0.7;
            }

            .out-of-stock-label {
                display: inline-block;
                color: #dc3545;
                font-size: 12px;
                font-weight: bold;
                border: 1px solid #dc3545;
                padding: 2px 6px;
                border-radius: 3px;
                margin-top: 5px;
            }
            .admin-reply {
                margin-top: 10px;
                margin-left: 20px;
                padding: 10px 15px;
                background-color: #f8f9fa;
                border-left: 3px solid #0d6efd;
                border-radius: 4px;
            }

            .reply-header {
                font-weight: bold;
                color: #0d6efd;
                margin-bottom: 5px;
            }

            .reply-header i {
                margin-right: 5px;
            }

            .reply-content {
                color: #333;
            }

        </style>
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

                <!-- Stock Status Indicator -->
                <div class="stock-info">
                    <% if (product.getQuantity() > 10) {%>
                    <i class="fa-solid fa-circle-check" style="color: #28a745;"></i>
                    <span class="stock-status in-stock">In Stock (<%= product.getQuantity()%> available)</span>
                    <% } else if (product.getQuantity() > 0) {%>
                    <i class="fa-solid fa-circle-exclamation" style="color: #ffc107;"></i>
                    <span class="stock-status low-stock">Low Stock (Only <%= product.getQuantity()%> left)</span>
                    <% } else { %>
                    <i class="fa-solid fa-circle-xmark" style="color: #dc3545;"></i>
                    <span class="stock-status sold-out">Out of Stock</span>
                    <% }%>
                </div>

                <ul style="font-weight: bold;list-style-type: disc;padding-left: 20px;">
                    <%= product.getSpecification()%>
                </ul>

                <% if (product.getQuantity() > 0) {%>
                <!-- Product in stock - Show Add to Cart form -->
                <form action="${pageContext.request.contextPath}/add-to-cart" method="post">
                    <input type="hidden" name="productId" value="<%= product.getId()%>" />
                    <input type="number" name="quantity" value="1" min="1" max="<%= product.getQuantity()%>" />
                    <button class="normal">Add To Cart</button>
                </form>
                <% } else { %>
                <!-- Product out of stock - Show Out of Stock message -->
                <div class="out-of-stock">
                    <span class="out-of-stock-badge">Out of Stock</span>
                    <p>Sorry, this item is currently out of stock. Please check back later or browse our similar products below.</p>
                    <button class="normal disabled-btn" disabled>Add To Cart</button>
                </div>
                <% }%>
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

                    <%
                        Reply reply = review.getReply();
                        if (reply != null && reply.getComment() != null && !reply.getComment().trim().isEmpty()) {
                    %>
                    <div class="admin-reply">
                        <div class="reply-header">
                            <i class="fa-solid fa-reply"></i> <span>Admin Response:</span>
                        </div>
                        <div class="reply-content">
                            <%= reply.getComment()%>
                        </div>
                    </div>
                    <%
                        }
                    %>
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

                        <% if (p.getQuantity() > 0) {%>
                        <a href="${pageContext.request.contextPath}/add-to-cart?productId=<%= p.getId()%>"><i class="fa-solid fa-cart-shopping cart"></i></a>
                            <% } else { %>
                        <span class="out-of-stock-label">Out of stock</span>
                        <% } %>
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