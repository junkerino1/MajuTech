<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Admin Panel</title>
        <link rel="shortcut icon" type="image/png" href="img/logos/favicon.png" />
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

            <!-- Include Sidebar -->
            <jsp:include page="sidebar.jsp" />
            <!--  Main wrapper -->
            <div class="body-wrapper">

                <jsp:include page="admin-header.jsp"/>
                <!-- Main Content -->
                <div class="container-fluid">

                    <%
                        String message = (String) request.getAttribute("message");
                        if (message != null && !message.isEmpty()) {
                    %>
                    <div class="card text-white bg-success mb-3" style="max-width: 100%;">
                        <div class="card-body">
                            <p class="card-text"><%= message%></p>
                        </div>
                    </div>
                    <%
                        }
                    %>
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title">Product List</h4>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Product Name</th>
                                            <th>Category ID</th>
                                            <th>Description</th>
                                            <th>Unit Price</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            List<Product> products = (List<Product>) request.getAttribute("products");
                                            if (products != null) {
                                                for (Product p : products) {
                                        %>
                                        <tr>
                                            <td><%= p.getId()%></td>
                                            <td><%= p.getProductName()%></td>
                                            <td><%= p.getCategoryId()%></td>
                                            <td><%= p.getDescription()%></td>
                                            <td><%= p.getUnitPrice()%></td>
                                            <td><%= p.getStatus()%></td>

                                            <td>
                                                <a href="edit-product.jsp?id=<%= p.getId()%>">
                                                    <button class="btn btn-sm btn-primary">
                                                        <i class="bi bi-pen"></i>
                                                    </button>
                                                </a>
                                                <form action="delete-product" method="post" style="display:inline;">
                                                    <input type="hidden" name="id" value="<%= p.getId()%>"/>
                                                    <button class="btn btn-sm btn-danger" type="submit">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            }
                                        %>
                                    </tbody>

                                </table>
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