<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Admin Panel</title>
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
            %>

            <!-- Include Sidebar -->
            <jsp:include page="sidebar.jsp" />

            <!--  Main wrapper -->
            <div class="body-wrapper">
                <jsp:include page="admin-header.jsp" />
                <div class="container-fluid">
                    <h5 class="card-title fw-semibold mb-4">Add a new product</h5>
                    <div class="card">
                        <div class="card-body">

                            <form action="${pageContext.request.contextPath}/add-product" method="post" enctype="multipart/form-data">
                                <div class="form-group-inline mb-3">
                                    <label class="form-label">Product Name</label>
                                    <input type="text" class="form-control" id="product_name" name="product_name"
                                           placeholder="Enter product name">
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label class="form-label">Category</label>
                                    <select class="form-select" id="category" name="category_id" required>
                                        <%
                                            if (categories != null) {
                                                for (Category category : categories) {
                                        %>
                                        <option value="<%= category.getId()%>"><%= category.getCategoryName()%></option>
                                        <%
                                                }
                                            }
                                        %>
                                    </select>
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label for="productDescription" class="form-label">Specification</label>
                                    <textarea class="form-control" id="specification" rows="3" name="specification"
                                              placeholder="Enter product specification"></textarea>
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea class="form-control" id="description" rows="3" name="description"
                                              placeholder="Enter product description"></textarea>
                                </div>

                                <div class="form-group-inline mb-3">
                                    <label class="form-label" for="unitPrice">Unit Price</label>
                                    <input type="number" class="form-control" id="unit_price" name="unit_price" placeholder="Enter product unit price" step="0.01" required />
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label for="productImage" class="form-label">Image</label>
                                    <input type="file" class="form-control" id="images" name="images" multiple>
                                </div>

                                <button type="submit" class="btn btn-primary">Submit</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <script src="${pageContext.request.contextPath}/script/sidebarmenu.js"></script>
    <script src="${pageContext.request.contextPath}/script/script.js"></script>
</body>

</html>