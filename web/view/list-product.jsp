<%@page import="model.Category"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="model.Admin" %>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" type="image" href="${pageContext.request.contextPath}/image/logo.png">
        <title>Admin Panel - Product List</title>
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

            /* Add styles for low stock */
            .low-stock {
                color: #dc3545;
                font-weight: bold;
            }

            /* Add styles for good stock */
            .good-stock {
                color: #28a745;
            }

            /* Fix table overflow issues */
            .table-responsive {
                overflow-x: auto;
                width: 100%;
            }

            .table {
                width: 100%;
                min-width: 100%; /* Ensure table takes full width */
                table-layout: fixed;
                margin-bottom: 0; /* Remove default bottom margin */
            }

            .table th, .table td {
                padding: 0.75rem;
                word-wrap: break-word;
                overflow-wrap: break-word;
            }

            /* Truncate long product names */
            .product-name {
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 100%; /* Make it use full width of the cell */
                display: block;
            }

            /* Tooltip for truncated text */
            .product-name-tooltip {
                position: relative;
                display: block; /* Changed to block to use full width */
                width: 100%;
            }

            .product-name-tooltip:hover .tooltip-text {
                visibility: visible;
                opacity: 1;
            }

            .tooltip-text {
                visibility: hidden;
                position: absolute;
                z-index: 1;
                bottom: 125%;
                left: 50%;
                transform: translateX(-50%);
                background-color: #333;
                color: #fff;
                text-align: center;
                border-radius: 6px;
                padding: 5px;
                width: auto;
                min-width: 150px;
                max-width: 300px;
                opacity: 0;
                transition: opacity 0.3s;
            }

            /* Adjusted column width control for better space utilization */
            .table th:nth-child(1), .table td:nth-child(1) {
                width: 5%;
            }
            .table th:nth-child(2), .table td:nth-child(2) {
                width: 22%;
            }
            .table th:nth-child(3), .table td:nth-child(3) {
                width: 15%;
            }
            .table th:nth-child(4), .table td:nth-child(4) {
                width: 15%;
                text-align: right;
            }
            .table th:nth-child(5), .table td:nth-child(5) {
                width: 10%;
            }
            .table th:nth-child(6), .table td:nth-child(6) {
                width: 13%;
                text-align: center;
            }
            .table th:nth-child(7), .table td:nth-child(7) {
                width: 20%;
                text-align: center;
            }

            .action-buttons {
                display: flex;
                gap: 5px;
                flex-wrap: wrap;
                justify-content: center; /* Center the buttons */
            }

            /* For smaller screens */
            @media (max-width: 768px) {
                .btn-sm {
                    padding: 0.25rem 0.4rem;
                }

                .table th:nth-child(4), .table td:nth-child(4),
                .table th:nth-child(6), .table td:nth-child(6) {
                    width: 10%;
                }

                .product-name {
                    max-width: 100%;
                }

                /* Force table to use full width on small screens */
                .table-responsive {
                    padding: 0;
                }

                .table {
                    width: 100% !important;
                }
            }

            /* Card styling to ensure full width */
            .card {
                width: 100%;
            }

            .card-body {
                padding: 1.25rem;
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
                        String message = (String) session.getAttribute("productMessage");
                        Admin admin = (Admin) session.getAttribute("admin");
                        if (message != null && !message.isEmpty()) {
                    %>
                    <div class="card text-white bg-success mb-3" id="message" style="max-width: 100%;">
                        <div class="card-body">
                            <p class="card-text"><%= message%></p>
                        </div>
                    </div>

                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const message = document.getElementById('message');

                            setTimeout(function () {
                                message.style.display = 'none';
                            }, 5000);
                        });
                    </script>

                    <%
                            session.removeAttribute("productMessage");
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
                                            <th>Category</th>
                                            <th>Unit Price</th>
                                            <th>Status</th>
                                            <th>Quantity</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            List<Product> products = (List<Product>) request.getAttribute("products");
                                            List<Category> category = (List<Category>) request.getAttribute("categories");
                                            if (products != null) {
                                                for (Product p : products) {
                                                    String categoryName = null;
                                                    for (Category c : category) {
                                                        if (c.getId() == p.getCategoryId()) {
                                                            categoryName = c.getCategoryName();
                                                            break;
                                                        }
                                                    }

                                        %>
                                        <tr>
                                            <td><%= p.getId()%></td>
                                            <td>
                                                <div class="product-name-tooltip">
                                                    <span class="product-name"><%= p.getProductName()%></span>
                                                    <span class="tooltip-text"><%= p.getProductName()%></span>
                                                </div>
                                            </td>
                                            <td><%= categoryName%></td>
                                            <td>RM <%= String.format("%.2f", p.getUnitPrice())%></td>
                                            <td><%= p.getStatus()%></td>
                                            <td class="<%= p.getQuantity() < 10 ? "low-stock" : "good-stock"%>">
                                                <%= p.getQuantity()%> 
                                                <% if (p.getQuantity() < 10) { %><span class="badge bg-danger">Low</span><% }%>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn btn-sm btn-primary" onclick="window.location.href = '${pageContext.request.contextPath}/admin/edit-product?id=<%= p.getId()%>'">
                                                        <i class="bi bi-pen"></i>
                                                    </button>

                                                    <% if (admin.getRole().equals("manager")) {%>
                                                    <form action="${pageContext.request.contextPath}/admin/delete-product" method="post" style="display:inline;" onsubmit="return confirmDelete();">
                                                        <button class="btn btn-sm btn-danger" type="submit">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                        <input type="hidden" name="id" value="<%= p.getId()%>"/>
                                                    </form>
                                                    <% } %>
                                                </div>
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
        <script>
                                                        function confirmDelete() {
                                                            return confirm("Are you sure you want to delete this product?");
                                                        }
        </script>
    </body>
</html>