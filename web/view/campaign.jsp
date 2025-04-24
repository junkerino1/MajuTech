<%@page import="model.Product"%>
<%@page import="model.CampaignItem"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Campaign" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Campaign</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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
                /* You can adjust this depending on how tall your submenu gets */
            }

            /* Product dropdown styles */
            .product-dropdown {
                display: none;
                background-color: #f8f9fa;
                border-top: 1px solid #dee2e6;
                padding: 15px;
                transition: all 0.3s ease;
            }

            .product-table {
                width: 100%;
                margin-top: 10px;
            }

            .product-table th {
                font-weight: 500;
                color: #6c757d;
                font-size: 0.85rem;
            }

            .product-table td {
                vertical-align: middle;
            }

            .product-image {
                width: 40px;
                height: 40px;
                object-fit: cover;
                border-radius: 4px;
            }

            .original-price {
                text-decoration: line-through;
                color: #6c757d;
            }

            .discounted-price {
                color: #dc3545;
                font-weight: 500;
            }

            .expand-btn {
                cursor: pointer;
                background: none;
                border: none;
                color: #0d6efd;
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
                <jsp:include page="admin-header.jsp" />

                <!-- Main Content -->
                <div class="container-fluid">

                    <%
                        List<Campaign> campaigns = (List<Campaign>) request.getAttribute("campaigns");
                        Map<Integer, List<CampaignItem>> campaignItemMap = (Map<Integer, List<CampaignItem>>) request.getAttribute("campaignItemMap");
                        Map<Integer, Integer> campaignItemCounts = (Map<Integer, Integer>) request.getAttribute("campaignItemCounts");
                        Map<Integer, Product> campaignItemProductMap = (Map<Integer, Product>) request.getAttribute("campaignItemProductMap");
                        int index = 1;
                    %>

                    <div class="card">

                        <%
                            String message = (String) session.getAttribute("campaignMessage");
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
                                session.removeAttribute("campaignMessage"); // remove it after display
                            }
                        %>

                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h4 class="card-title m-0">Campaign List</h4>
                                <a href="${pageContext.request.contextPath}/admin/create-campaign" class="btn btn-sidebar-match">
                                    <i class="bi bi-plus-circle"></i> Create Campaign
                                </a>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>No</th>
                                            <th>Promotion Name</th>
                                            <th>Start Date</th>
                                            <th>End Date</th>
                                            <th>Discount (%)</th>
                                            <th>Total Products</th>
                                            <th>Actions</th>
                                            <th>Products</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (Campaign campaign : campaigns) {
                                                int campaignId = campaign.getId();
                                                List<CampaignItem> items = campaignItemMap.get(campaignId);
                                                int count = campaignItemCounts.getOrDefault(campaignId, 0);
                                                String toggleId = "product-list-" + campaignId;
                                        %>
                                        <tr>
                                            <td><%= index++%></td>
                                            <td><%= campaign.getCampaignName()%></td>
                                            <td><%= campaign.getDateStart()%></td>
                                            <td><%= campaign.getDateEnd()%></td>
                                            <td><%= campaign.getDiscountPercentage()%>%</td>
                                            <td><%= count%></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/edit-campaign?id=<%= campaign.getId()%>" class="btn btn-sm btn-primary">
                                                    <i class="bi bi-pen"></i>
                                                </a>
                                                <form action="${pageContext.request.contextPath}/delete-campaign" method="post" style="display:inline;">
                                                    <input type="hidden" name="id" value="<%= campaign.getId()%>">
                                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this campaign?');">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                            <td>
                                                <button class="expand-btn" onclick="toggleProductList('<%= toggleId%>')">
                                                    <i class="bi bi-chevron-down"></i> Show Products
                                                </button>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td colspan="8" class="p-0">
                                                <div id="<%= toggleId%>" class="product-dropdown" style="display: none;">
                                                    <h6 class="px-3 pt-3">Promotion Products</h6>
                                                    <table class="product-table table table-bordered mb-0">
                                                        <thead>
                                                            <tr>
                                                                <th>Image</th>
                                                                <th>Product Name</th>
                                                                <th>Original Price</th>
                                                                <th>Discounted Price</th>
                                                                <th>Savings</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <%
                                                                if (items != null && !items.isEmpty()) {
                                                                    for (CampaignItem item : items) {
                                                                        Product product = campaignItemProductMap.get(item.getId());
                                                                        if (product != null) {
                                                            %>
                                                            <tr>
                                                                <td><img src="<%= product.getImage1()%>" alt="Product" class="product-image" width="60"></td>
                                                                <td><%= product.getProductName()%></td>
                                                                <td class="original-price">RM <%= String.format("%.2f", product.getUnitPrice())%></td>
                                                                <td class="discounted-price">RM <%= String.format("%.2f", item.getDiscountedPrice())%></td>
                                                                <td>RM <%= String.format("%.2f", product.getUnitPrice() - item.getDiscountedPrice())%></td>
                                                            </tr>
                                                            <%
                                                                    }
                                                                }
                                                            } else {
                                                            %>
                                                            <tr>
                                                                <td colspan="5" class="text-center">No products in this campaign.</td>
                                                            </tr>
                                                            <%
                                                                }
                                                            %>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <%
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
        <!-- Custom script for product dropdowns -->
        <script>
                                                    function toggleProductList(id) {
                                                        const productList = document.getElementById(id);
                                                        const button = event.currentTarget;

                                                        if (productList.style.display === 'block') {
                                                            productList.style.display = 'none';
                                                            button.innerHTML = '<i class="bi bi-chevron-down"></i> Show Products';
                                                        } else {
                                                            // Close all other open dropdowns first
                                                            const allDropdowns = document.querySelectorAll('.product-dropdown');
                                                            allDropdowns.forEach(dropdown => {
                                                                dropdown.style.display = 'none';
                                                            });

                                                            // Reset all other buttons
                                                            const allButtons = document.querySelectorAll('.expand-btn');
                                                            allButtons.forEach(btn => {
                                                                btn.innerHTML = '<i class="bi bi-chevron-down"></i> Show Products';
                                                            });

                                                            // Open the clicked dropdown
                                                            productList.style.display = 'block';
                                                            button.innerHTML = '<i class="bi bi-chevron-up"></i> Hide Products';
                                                        }
                                                    }
        </script>
    </body>
</html>
