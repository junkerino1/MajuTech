<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="model.Product"%>
<%@page import="model.User"%>
<%@page import="java.util.Map"%>
<%@page import="model.OrderItem"%>
<%@page import="model.Order"%>
<%@page import="model.ShippingAddress"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Maju Tech</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
        <style>
            .page-wrapper {
                display: flex;
            }

            .body-wrapper {
                width: calc(100% - 260px);
                margin-left: 260px;
                min-height: 100vh;
            }

            .container-fluid {
                padding: 30px;
            }

            table {
                background-color: white;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
            }

            .table th {
                font-weight: 600;
                color: #495057;
            }

            .btn-view {
                background-color: #3498db;
                color: white;
            }

            .btn-update {
                background-color: #2ecc71;
                color: white;
            }

            .status-badge {
                padding: 5px 10px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 500;
            }

            .modal-product-img {
                max-width: 80px;
                height: auto;
            }

            .update-status-form label {
                font-weight: 500;
                margin-bottom: 5px;
            }

            .update-status-form input,
            .update-status-form textarea,
            .update-status-form select {
                margin-bottom: 15px;
            }

            /* Responsive adjustments */
            @media (max-width: 992px) {
                .left-sidebar {
                    width: 220px;
                }
                .body-wrapper {
                    width: calc(100% - 220px);
                    margin-left: 220px;
                }
            }

            @media (max-width: 768px) {
                .left-sidebar {
                    width: 0;
                    transform: translateX(-100%);
                    transition: all 0.3s;
                }
                .body-wrapper {
                    width: 100%;
                    margin-left: 0;
                }
                .sidebar-open .left-sidebar {
                    width: 260px;
                    transform: translateX(0);
                }
            }
        </style>
    </head>

    <body>

        <!-- Include Sidebar -->
        <jsp:include page="sidebar.jsp" />

        <!--  Main wrapper -->
        <div class="body-wrapper">
            <jsp:include page="admin-header.jsp" />

            <%
                List<Order> orders = (List<Order>) request.getAttribute("orders");
                Map<Order, List<OrderItem>> orderItemMap = (Map<Order, List<OrderItem>>) request.getAttribute("orderItemMap");
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy hh:mm a");
            %>

            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="mb-0">Order List</h4>
                    <div class="d-flex">
                        <input type="text" class="form-control me-2" placeholder="Search" style="width:200px;">
                    </div>
                </div>

                <div class="card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>User</th>
                                        <th>Order Date</th>
                                        <th>Status</th>
                                        <th>Shipping Address</th>
                                        <th>Subtotal (RM)</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Order order : orders) {
                                            int orderId = order.getOrderId();
                                            User user = order.getUser();
                                            ShippingAddress address = order.getShippingAddress();
                                            List<OrderItem> items = orderItemMap.get(order);
                                            String orderDetailsModal = "orderDetailsModal_" + orderId;
                                            String orderStatusModal = "orderStatusModal_" + orderId;
                                    %>
                                    <tr>
                                        <td><%= orderId%></td>
                                        <td><%= user.getUsername()%></td>
                                        <td><%= order.getDate().format(formatter)%></td>
                                        <td>
                                            <span class="badge 
                                                  <%="Processing".equals(order.getStatus()) ? "bg-warning text-dark"
                                                          : "Shipped".equals(order.getStatus()) ? "bg-info text-dark"
                                                          : "bg-success text-dark"%>">
                                                <%= order.getStatus()%>
                                            </span>
                                        </td>
                                        <td><%= address.getStreet1()%>, <br><%= address.getStreet2()%>, <br><%= address.getState()%>, <%= address.getPostcode()%></td>
                                        <td>RM <%= String.format("%.2f", order.getTotalAmount())%></td>
                                        <td>
                                            <button class="btn btn-sm btn-view" data-bs-toggle="modal" data-bs-target="#<%= orderDetailsModal%>">View Details</button>
                                            <button class="btn btn-sm btn-update" data-bs-toggle="modal" data-bs-target="#<%= orderStatusModal%>">Update Status</button>
                                        </td>
                                    </tr>
                                </tbody>
                                <% } %>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%
            for (Order order : orders) {
                int orderId = order.getOrderId();
                User user = order.getUser();
                ShippingAddress address = order.getShippingAddress();
                List<OrderItem> items = orderItemMap.get(order);
                String orderDetailsModal = "orderDetailsModal_" + orderId;
                String orderStatusModal = "orderStatusModal_" + orderId;
        %>
        <!-- Order Details Modal -->
        <div class="modal fade" id="<%= orderDetailsModal%>" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Order Details - #<%= orderId%></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-3">
                        <div class="mb-3">
                            <p><strong>Date:</strong> <%= order.getDate().format(formatter)%></p>
                            <p><strong>Status:</strong> <%= order.getStatus()%></p>
                            <p><strong>Payment:</strong> <%= order.getPaymentMethod()%></p>
                            <p><strong>Ship To:</strong> <%= address.getStreet1()%>, <%= address.getStreet2()%>, <%= address.getState()%>, <%= address.getPostcode()%></p>
                        </div>

                        <table class="table table-sm">
                            <thead>
                                <tr>
                                    <th>Item</th>
                                    <th>Qty</th>
                                    <th>Price (RM)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (items != null && !items.isEmpty()) {
                                        for (OrderItem item : items) {
                                            Product product = item.getProduct();
                                %>
                                <tr>
                                    <td><%= product.getProductName()%></td>
                                    <td><%= item.getQuantity()%></td>
                                    <td><%= String.format("%.2f", item.getCurrentPrice())%></td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="2" class="text-end"><strong>Total:</strong></td>
                                    <td><strong><%= String.format("%.2f", order.getTotalAmount())%></strong></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#<%= orderStatusModal%>">Update Status</button>
                    </div>
                </div>

            </div>
        </div>

        <div class="modal fade" id="<%= orderStatusModal%>" tabindex="-1" aria-labelledby="updateStatusModalLabel"
             aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateStatusModalLabel">Update Status</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="update-status-form-<%= orderId%>">
                            <input type="hidden" name="orderId" value="<%= orderId%>" />
                            <div class="mb-3">
                                <label for="update-order-id" class="form-label">Order ID</label>
                                <input type="text" class="form-control" id="update-order-id" value="<%= orderId%>" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="status-<%= orderId%>" class="form-label">Update Status</label>
                                <select class="form-select" id="status-<%= orderId%>" name="status">
                                    <option value="Pending" <%= "Processing".equals(order.getStatus()) ? "selected" : ""%>>Processing</option>
                                    <option value="Shipped" <%= "Shipped".equals(order.getStatus()) ? "selected" : ""%>>Shipped</option>
                                    <option value="Delivered" <%= "Delivered".equals(order.getStatus()) ? "selected" : ""%>>Delivered</option>
                                </select>
                            </div>
                            <div class="text-end">
                                <button type="button" class="btn btn-primary btn-sm" onclick="submitStatusUpdate('<%= orderId%>')">Update</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>


        <%
            }
        %>

        <script>


            function submitStatusUpdate(orderId) {
                const form = document.getElementById('update-status-form-' + orderId);
                const status = document.getElementById('status-' + orderId).value;

                // Create URL-encoded data string
                const data = new URLSearchParams();
                data.append('orderId', orderId);
                data.append('status', status);

                fetch('${pageContext.request.contextPath}/admin/update-status', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: data.toString()
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                alert("Successfully updated order status!");
                                location.reload();
                            } else {
                                alert("Failed to update order status.");
                            }
                        })
                        .catch(error => {
                            console.error("Error updating status:", error);
                            alert("An error occurred. Please try again.");
                        });
            }


        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/script/sidebarmenu.js"></script>
        <script src="${pageContext.request.contextPath}/script/script.js"></script>
    </body>

</html>