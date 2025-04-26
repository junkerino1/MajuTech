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
        <div class="container">
                <form method="get" class="search-container" action="${pageContext.request.contextPath}/product">
                    <input type="text" name="search" class="search-input" placeholder="Search for tech gadgets...">
                    <button type="submit" class="search-button" style="border:none;">Search</button>
                </form>
        </div>
        <div class="fe-title">
            <h2>Products</h2>
            <p>Buy more! Save more!</p>
        </div>

        <div class="shop-content">
            <!--Aside Section-->
            <aside class="filters-section">
                <a href="${pageContext.request.contextPath}/product" class="clear-filters">Clear all filters</a>
                <form method="get" action="${pageContext.request.contextPath}/product">
                    <!-- Categories Filter -->
                    <div class="filter-group">
                        <div class="filter-title" onclick="toggleFilter(this)">
                            <span>Categories</span>
                            <span class="filter-arrow">▼</span>
                        </div>
                        <div class="filter-content">
                            <div class="checkbox-group">
                                <label class="checkbox-label">
                                    <input type="checkbox" name="categoryId" value="5"> Lifestyle
                                </label>
                                <label class="checkbox-label">
                                    <input type="checkbox" name="categoryId" value="3"> Phone
                                </label>
                                <label class="checkbox-label">
                                    <input type="checkbox" name="categoryId" value="4"> Accessories
                                </label>
                                <label class="checkbox-label">
                                    <input type="checkbox" name="categoryId" value="6"> Tablet
                                </label>
                                <label class="checkbox-label">
                                    <input type="checkbox" name="categoryId" value="2"> Laptop & PC
                                </label>
                                <label class="checkbox-label">
                                    <input type="checkbox" name="categoryId" value="1"> Audio
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
                                <input type="number" name="min" placeholder="Min" min="1">
                                <input type="number" name="max" placeholder="Max" max="9999">
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="clear-filters">Apply Filters</button>
                </form>
            </aside>

            <section id="product1" class="section-p1">

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
        <script src="${pageContext.request.contextPath}/script/clientscript.js"></script>
    </body>


    <jsp:include page="client-footer.jsp"/>
</html>
