<%@page import="model.Product"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" type="image" href="${pageContext.request.contextPath}/image/logo.png">
        <title>Admin Panel - Edit Product</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
        <style>
            .first-level {
                max-height: 0;
                overflow: hidden;
                transition: max-height 0.3s ease;
                list-style: none;
                padding-left: 1rem;
            }

            .first-level.show {
                max-height: 500px;
            }
        </style>
    </head>

    <body>
        <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
             data-sidebar-position="fixed" data-header-position="fixed">

            <%
                List<Category> categories = (List<Category>) request.getAttribute("categories");
                Product product = (Product) request.getAttribute("product");
            %>

            <!-- Include Sidebar -->
            <jsp:include page="sidebar.jsp" />

            <!--  Main wrapper -->
            <div class="body-wrapper">
                <jsp:include page="admin-header.jsp" />
                <div class="container-fluid">
                    <h5 class="card-title fw-semibold mb-4">Editing Product: <%= product.getProductName() %></h5>
                    <div class="card">
                        <div class="card-body">

                            <form action="${pageContext.request.contextPath}/admin/edit-product" method="post" enctype="multipart/form-data">
                                <input type="hidden" value="<%= product.getId()%>" name="product_id">
                                <div class="form-group-inline mb-3">
                                    <label class="form-label">Product Name</label>
                                    <input type="text" class="form-control" id="product_name" name="product_name"
                                           value="<%= product.getProductName()%>">
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label class="form-label">Category</label>
                                    <select class="form-select" id="category" name="category_id" required>
                                        <%
                                            if (categories != null) {
                                                for (Category category : categories) {
                                                    boolean isSelected = (category.getId() == product.getCategoryId());
                                        %>
                                        <option value="<%= category.getId()%>" <%= isSelected ? "selected" : ""%>>
                                            <%= category.getCategoryName()%>
                                        </option>
                                        <%
                                                }
                                            }
                                        %>
                                    </select>
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label for="productDescription" class="form-label">Specification</label>
                                    <textarea class="form-control" id="specification" rows="3" name="specification"><%= product.getSpecification()%></textarea>
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea class="form-control" id="description" rows="3" name="description"><%= product.getDescription()%></textarea>
                                </div>

                                <div class="form-group-inline mb-3">
                                    <label class="form-label" for="unitPrice">Unit Price</label>
                                    <input type="number" class="form-control" id="unit_price" name="unit_price" value="<%= product.getUnitPrice()%>" step="0.01" required />
                                </div>

                                <!-- Added Quantity Field -->
                                <div class="form-group-inline mb-3">
                                    <label class="form-label" for="quantity">Quantity</label>
                                    <input type="number" class="form-control" id="quantity" name="quantity" value="<%= product.getQuantity()%>" min="0" max="10000" required />
                                </div>

                                <div class="form-group-inline mb-3">
                                    <label for="productImage" class="form-label">Images 1</label>
                                    <img src="<%= product.getImage1()%>" style="width:150px;">
                                    <input type="file" class="form-control" id="images" name="image1">
                                    <input type="hidden" name="existingImage1" value="<%= product.getImage1()%>">
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label for="productImage" class="form-label">Image 2</label>
                                    <img src="<%= product.getImage2()%>" style="width:150px;">
                                    <input type="file" class="form-control" id="images" name="image2">
                                    <input type="hidden" name="existingImage2" value="<%= product.getImage2()%>">
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label for="productImage" class="form-label">Image 3</label>
                                    <img src="<%= product.getImage3()%>" style="width:150px;">
                                    <input type="file" class="form-control" id="images" name="image3">
                                    <input type="hidden" name="existingImage3" value="<%= product.getImage3()%>">
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label for="productImage" class="form-label">Image 4</label>
                                    <img src="<%= product.getImage4()%>" style="width:150px;">
                                    <input type="file" class="form-control" id="images" name="image4">
                                    <input type="hidden" name="existingImage4" value="<%= product.getImage4()%>">
                                </div>

                                <button type="submit" class="btn btn-primary">Submit</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/script/sidebarmenu.js"></script>
        <script src="${pageContext.request.contextPath}/script/script.js"></script>
    </body>

</html>