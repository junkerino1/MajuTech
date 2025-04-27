<%@page import="model.Category"%>
<%@page import="model.Product"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="model.Order"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" type="image" href="${pageContext.request.contextPath}/image/logo.png">
        <title>Admin Panel - Dashboard</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .sale-card {
                margin-bottom: 1rem;
            }

            .small-images {
                width: 50px;
                height: 50px;
                border-radius: 4px;
                object-fit: cover;
                border: 1px solid #dee2e6;
            }

            .filter-bar {
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 1rem;
                margin-bottom: 1.5rem;
            }

            .stats-card {
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
                transition: transform 0.3s ease;
            }

            .stats-card:hover {
                transform: translateY(-5px);
            }

            .stats-icon {
                width: 48px;
                height: 48px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 10px;
            }

            .product-detail-row {
                transition: background-color 0.2s;
            }

            .product-detail-row:hover {
                background-color: rgba(0, 0, 0, 0.02);
            }

            #chartContainer {
                height: 350px;
                width: 100%;
                margin-bottom: 20px;
            }
            
            /* Added styles for product table to prevent overflow */
            .product-table-container {
                overflow-x: auto;
            }
            
            .product-name-cell {
                max-width: 200px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            
            @media (max-width: 768px) {
                .product-name-cell {
                    max-width: 150px;
                }
            }
        </style>
    </head>

    <body>
        <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
             data-sidebar-position="fixed" data-header-position="fixed">

            <!-- Include Sidebar -->
            <jsp:include page="sidebar.jsp" />

            <body>
                <!--  Body Wrapper -->
                <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
                     data-sidebar-position="fixed" data-header-position="fixed">
                    <!--  Main wrapper -->
                    <div class="body-wrapper">
                        <jsp:include page="admin-header.jsp" />
                        <div class="container-fluid">
                            <%
                                int totalOrders = (int) request.getAttribute("totalOrders");
                                double totalSales = (double) request.getAttribute("totalSales");
                                int totalQuantity = (int) request.getAttribute("totalQuantity");
                                double totalDiscount = (double) request.getAttribute("totalDiscount");

                                List<Order> recentTransaction = (List<Order>) request.getAttribute("recentTransaction");

                                List<Integer> orderStats = (List<Integer>) request.getAttribute("orderStats");
                                List<Double> dailySales = (List<Double>) request.getAttribute("dailySales");
                                List<Object[]> topProducts = (List<Object[]>) request.getAttribute("topProducts");

                                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyy hh:mm a");
                            %>


                            <div class="row">
                                <!-- Sales Statistics Cards -->
                                <div class="row mb-4">
                                    <div class="col-xl-3 col-md-6 mb-3">
                                        <div class="card stats-card bg-white h-100">
                                            <div class="card-body">
                                                <div class="d-flex align-items-start justify-content-between">
                                                    <div>
                                                        <h5 class="card-title mb-1 text-muted">Total Sales</h5>
                                                        <h3 class="mb-0 fw-bold">RM <%= String.format("%.2f", totalSales)%></h3>
                                                    </div>
                                                    <div class="stats-icon bg-primary-subtle text-primary">
                                                        <i class="bi bi-cash-stack"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-3 col-md-6 mb-3">
                                        <div class="card stats-card bg-white h-100">
                                            <div class="card-body">
                                                <div class="d-flex align-items-start justify-content-between">
                                                    <div>
                                                        <h5 class="card-title mb-1 text-muted">Total Orders</h5>
                                                        <h3 class="mb-0 fw-bold"><%= totalOrders%></h3>
                                                    </div>
                                                    <div class="stats-icon bg-success-subtle text-success">
                                                        <i class="bi bi-cart-check"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-3 col-md-6 mb-3">
                                        <div class="card stats-card bg-white h-100">
                                            <div class="card-body">
                                                <div class="d-flex align-items-start justify-content-between">
                                                    <div>
                                                        <h5 class="card-title mb-1 text-muted">Products Sold</h5>
                                                        <h3 class="mb-0 fw-bold"><%= totalQuantity%></h3>
                                                    </div>
                                                    <div class="stats-icon bg-warning-subtle text-warning">
                                                        <i class="bi bi-boxes"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-3 col-md-6 mb-3">
                                        <div class="card stats-card bg-white h-100">
                                            <div class="card-body">
                                                <div class="d-flex align-items-start justify-content-between">
                                                    <div>
                                                        <h5 class="card-title mb-1 text-muted">Total Discounts</h5>
                                                        <h3 class="mb-0 fw-bold">RM <%= String.format("%.2f", totalDiscount)%></h3>
                                                    </div>
                                                    <div class="stats-icon bg-danger-subtle text-danger">
                                                        <i class="bi bi-tag"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="mb-3 mb-sm-0">
                                    <h5 class="card-title fw-semibold">Sales Overview</h5>
                                </div>
                                <div class="col-lg-8 d-flex align-items-strech">
                                    <div class="card w-100">
                                        <div class="card-body">
                                            <div class="d-sm-flex d-block align-items-center justify-content-between mb-9">
                                                <div id="chartContainer">
                                                    <canvas id="weeklySalesChart"></canvas>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <!-- Yearly Breakup -->
                                            <div class="card overflow-hidden">
                                                <div class="card-body p-4">
                                                    <div class="d-sm-flex d-block align-items-center justify-content-between mb-9">
                                                        <div id="chartContainer">
                                                            <canvas id="productShareChart"></canvas>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="card w-100">
                                    <div class="card-body p-4">
                                        <h5 class="card-title fw-semibold mb-4">Top 10 Products Sales Report</h5>
                                        <div class="product-table-container">
                                            <table class="table text-nowrap mb-0 align-middle">
                                                <thead class="text-white" style="background-color: rgba(75, 192, 192, 0.2);">
                                                    <tr>
                                                        <th class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0">#</h6>
                                                        </th>
                                                        <th class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0">Product</h6>
                                                        </th>
                                                        <th class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0">Category</h6>
                                                        </th>
                                                        <th class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0">Units Sold</h6>
                                                        </th>
                                                        <th class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0">Total Revenue</h6>
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        List<Category> categories = (List<Category>) request.getAttribute("categories");

                                                        int counter = 1;

                                                        for (Object[] row : topProducts) {
                                                            Integer productId = (Integer) row[0];
                                                            String productName = (String) row[1];
                                                            Double unitPrice = (Double) row[2];
                                                            String image1 = (String) row[3];
                                                            Integer categoryId = (Integer) row[4];
                                                            Long totalSold = (Long) row[5];

                                                            String categoryName = null;
                                                            for (Category c : categories) {
                                                                if (c.getId() == categoryId) {
                                                                    categoryName = c.getCategoryName();
                                                                    break;
                                                                }
                                                            }
                                                    %>
                                                    <tr>
                                                        <td class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0"><%= counter++%></h6>
                                                        </td>
                                                        <td class="border-bottom-0">
                                                            <div class="d-flex align-items-center">
                                                                <img src="<%= image1%>" alt="<%= productName%>" class="small-images" style="margin-right: 15px">
                                                                <h6 class="fw-semibold mb-0 product-name-cell" title="<%= productName%>"><%= productName%></h6>
                                                            </div>
                                                        </td>
                                                        <td class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0"><%= categoryName != null ? categoryName : "Unknown"%></h6>
                                                        </td>
                                                        <td class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0"><%= totalSold%></h6>
                                                        </td>
                                                        <td class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0">
                                                                RM <%= String.format("%.2f", totalSold * unitPrice)%>
                                                            </h6>
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


                            <div class="row">
                                <div class="card w-100">
                                    <div class="card-body p-4">
                                        <h5 class="card-title fw-semibold mb-4" >Recent Transactions</h5>
                                        <div class="table-responsive">
                                            <table class="table text-nowrap mb-0 align-middle">
                                                <thead class="text-dark fs-4" style="background-color: rgba(153, 102, 255, 0.2)">
                                                    <tr>
                                                        <th class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0">Order ID</h6>
                                                        </th>
                                                        <th class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0">Payment Method</h6>
                                                        </th>
                                                        <th class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0">Purchased By</h6>
                                                        </th>
                                                        <th class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0">Status</h6>
                                                        </th>
                                                        <th class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0">Total Amount</h6>
                                                        </th>
                                                        <th class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0">Purchase Date</h6>
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>

                                                    <%
                                                        for (Order order : recentTransaction) {
                                                    %>

                                                    <tr>
                                                        <td class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0"><%= order.getOrderId()%></h6>
                                                        </td>
                                                        <td class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-1"><%= order.getPaymentMethod()%></h6>
                                                        </td>
                                                        <td class="border-bottom-0">
                                                            <p class="mb-0 fw-normal"><%= order.getUser().getUsername()%></p>
                                                        </td>
                                                        <td class="border-bottom-0">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <span class="badge 
                                                                      <%="Processing".equals(order.getStatus()) ? "bg-warning text-dark"
                                                                              : "Shipped".equals(order.getStatus()) ? "bg-info text-dark"
                                                                              : "bg-success text-dark"%>">
                                                                    <%= order.getStatus()%>
                                                                </span>
                                                            </div>
                                                        </td>
                                                        <td class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0 fs-4">RM <%= String.format("%.2f", order.getTotalAmount())%></h6>
                                                        </td>
                                                        <td class="border-bottom-0">
                                                            <h6 class="fw-semibold mb-0 fs-4"><%= order.getDate().format(formatter)%></h6>
                                                        </td>
                                                    </tr>

                                                    <%}%>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>



                        </div>
                    </div>
                </div>

        </div>


        <script src="${pageContext.request.contextPath}/script/sidebarmenu.js"></script>
        <script src="${pageContext.request.contextPath}/script/script.js"></script>

        <script>
            // Sample Data for Pie Chart (Product Share)
            const statusLabel = ['Delivered', 'Shipped', 'Processing'];

            const stats = <%= orderStats%>;

            new Chart(document.getElementById("productShareChart"), {
                type: 'pie',
                data: {
                    labels: statusLabel,
                    datasets: [{
                            data: stats,
                            backgroundColor: [
                                '#AFE1AF', '#E1C16E', '#FAA0A0'
                            ], borderWidth: 1
                        }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        title: {
                            display: true,
                            text: 'Order Process Statistics'
                        }
                    }
                }
            });

            // Data for Bar Chart (Weekly Sales)
            const dateLabels = [];

            for (let i = 6; i >= 0; i--) {
                const date = new Date();
                date.setDate(date.getDate() - i);

                const formatted = date.toLocaleDateString('en-GB', {
                    day: 'numeric',
                    month: 'short'
                });

                dateLabels.push(formatted);
            }

            const salesData = <%= dailySales%>;

            new Chart(document.getElementById("weeklySalesChart"), {
                type: 'bar',
                data: {
                    labels: dateLabels,
                    datasets: [{
                            label: 'Total Revenue (RM)',
                            data: salesData,
                            backgroundColor: [
                                'rgba(255, 99, 132, 0.2)',
                                'rgba(255, 159, 64, 0.2)',
                                'rgba(255, 205, 86, 0.2)',
                                'rgba(75, 192, 192, 0.2)',
                                'rgba(54, 162, 235, 0.2)',
                                'rgba(153, 102, 255, 0.2)',
                                'rgba(201, 203, 207, 0.2)'
                            ],
                            borderColor: [
                                'rgb(255, 99, 132)',
                                'rgb(255, 159, 64)',
                                'rgb(255, 205, 86)',
                                'rgb(75, 192, 192)',
                                'rgb(54, 162, 235)',
                                'rgb(153, 102, 255)',
                                'rgb(201, 203, 207)'
                            ],
                            borderWidth: 1
                        }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        title: {
                            display: true,
                            text: 'Daily Sales Revenue'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        </script>
    </body>

</html>