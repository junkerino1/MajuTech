<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="model.Product" %>

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
        <!--Aside Section-->
        <aside class="filters-section">
            <a href="#" class="clear-filters">Clear all filters</a>

            <!-- Categories Filter -->
            <div class="filter-group">
                <div class="filter-title" onclick="toggleFilter(this)">
                    <span>Categories</span>
                    <span class="filter-arrow">▼</span>
                </div>
                <div class="filter-content">
                    <div class="checkbox-group">
                        <label class="checkbox-label">
                            <input type="checkbox" name="category" value="lifestyle"> Lifestyle
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="category" value="phone"> Phone
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="category" value="accessories"> Accessories
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="category" value="tablet"> Tablet
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="category" value="laptop"> Laptop & PC
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="category" value="audio"> Audio
                        </label>
                    </div>
                </div>
            </div>

            <!-- Price Range Filter -->
            <div class="filter-group">
                <div class="filter-title" onclick="toggleFilter(this)">
                    <span>Price Range</span>
                    <span class="filter-arrow">▼</span>
                </div>
                <div class="filter-content">
                    <div class="price-inputs">
                        <input type="number" placeholder="Min" min="0">
                        <input type="number" placeholder="Max" min="0">
                    </div>
                    <input type="range" min="0" max="2000" value="1000" class="range-input">
                </div>
            </div>

        </aside>
        
        <section id="product1" class="section-p1">
            <h2>Products</h2>
            <p class="heading">Buy more! Save more!</p>
            <%
                List<Product> products = (List<Product>) request.getAttribute("products");
            %>
            <div class="pro-container">
                <% if (products != null) {
                        for (Product p : products) {%>
                <div class="pro" onclick="window.location.href = '${pageContext.request.contextPath}/product/<%= p.getId()%>';">
                    <img src="<%= p.getImage1()%>">
                    <div class="des">
                        <h5><%= p.getProductName()%></h5>
                        <h4>RM <%= p.getUnitPrice()%></h4> 
                        <a href="#"><i class="fa-solid fa-cart-shopping cart"></i></a>
                    </div>
                </div>
                <%  }
                    }%>
            </div>
    </body>

    <script src="${pageContext.request.contextPath}/script/script.js"></script>
    <jsp:include page="client-footer.jsp"/>
</html>
