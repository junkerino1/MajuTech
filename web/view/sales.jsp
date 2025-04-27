<%@page import="java.time.LocalDate"%>
<%@page import="java.util.Map"%>
<%@page import="model.Category"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" type="image" href="${pageContext.request.contextPath}/image/logo.png">
        <title>Admin Panel - Sales List</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
        <style>
            .sale-card {
                margin-bottom: 1rem;
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

            .chart-container {
                position: relative;
                height: 250px;
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

                <%
                    List<Map<String, Object>> monthlyData = (List<Map<String, Object>>) request.getAttribute("monthlyComparison");
                    List<Map<LocalDate, Object[]>> dailySalesList = (List<Map<LocalDate, Object[]>>) request.getAttribute("dailyReport");
                    List<Map<String, Object[]>> monthlySalesList = (List<Map<String, Object[]>>) request.getAttribute("monthlyReport");

                    Map<String, Object> currentMonth = monthlyData.get(0);
                    Map<String, Object> previousMonth = monthlyData.get(1);

                    // Get raw values
                    double currentSales = ((Number) currentMonth.get("sales")).doubleValue();
                    double previousSales = ((Number) previousMonth.get("sales")).doubleValue();
                    int currentOrders = ((Number) currentMonth.get("orders")).intValue();
                    int previousOrders = ((Number) previousMonth.get("orders")).intValue();
                    int currentQuantity = ((Number) currentMonth.get("quantity")).intValue();
                    int previousQuantity = ((Number) previousMonth.get("quantity")).intValue();
                    double currentDiscount = ((Number) currentMonth.get("discount")).doubleValue();
                    double previousDiscount = ((Number) previousMonth.get("discount")).doubleValue();

                    // Calculate percentage changes
                    double salesChangePercent = previousSales != 0
                            ? ((currentSales - previousSales) / previousSales) * 100 : 0;
                    double ordersChangePercent = previousOrders != 0
                            ? ((currentOrders - previousOrders) / (double) previousOrders) * 100 : 0;
                    double quantityChangePercent = previousQuantity != 0
                            ? ((currentQuantity - previousQuantity) / (double) previousQuantity) * 100 : 0;
                    double discountChangePercent = previousDiscount != 0
                            ? ((currentDiscount - previousDiscount) / previousDiscount) * 100 : 0;
                %>

                <div class="container-fluid">
                    <h4 class="fw-bold py-3 mb-2">Sales Report</h4>

                    <!-- Sales Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-xl-3 col-md-6 mb-3">
                            <div class="card stats-card bg-white h-100">
                                <div class="card-body">
                                    <div class="d-flex align-items-start justify-content-between">
                                        <div>
                                            <h5 class="card-title mb-1 text-muted">Total Sales</h5>
                                            <h3 class="mb-0 fw-bold">RM <%= String.format("%.2f", currentMonth.get("sales"))%></h3>
                                            <small class="<%= salesChangePercent >= 0 ? "text-success" : "text-danger"%>">
                                                <%= salesChangePercent >= 0 ? "+" : ""%><%= String.format("%.1f", salesChangePercent)%>% from last month
                                            </small>
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
                                            <h3 class="mb-0 fw-bold"><%= currentMonth.get("orders")%></h3>
                                            <small class="<%= ordersChangePercent >= 0 ? "text-success" : "text-danger"%>">
                                                <%= salesChangePercent >= 0 ? "+" : ""%><%= String.format("%.1f", salesChangePercent)%>% from last month
                                            </small>
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
                                            <h3 class="mb-0 fw-bold"><%= currentMonth.get("quantity")%></h3>
                                            <small class="<%= quantityChangePercent >= 0 ? "text-success" : "text-danger"%>">
                                                <%= salesChangePercent >= 0 ? "+" : ""%><%= String.format("%.1f", salesChangePercent)%>% from last month
                                            </small>
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
                                            <h3 class="mb-0 fw-bold">RM <%= String.format("%.2f", currentMonth.get("discount"))%></h3>
                                            <small class="<%= discountChangePercent >= 0 ? "text-success" : "text-danger"%>">
                                                <%= salesChangePercent >= 0 ? "+" : ""%><%= String.format("%.1f", salesChangePercent)%>% from last month
                                            </small>
                                        </div>
                                        <div class="stats-icon bg-danger-subtle text-danger">
                                            <i class="bi bi-tag"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/admin/sales/details" class="d-flex justify-content-md-end gap-2 flex-wrap">
                        <h5 class="mt-2">Search by date: </h5>
                        <input type="date" name="date" class="form-control w-auto" />
                        <button class="btn btn-primary" type="submit">
                            <i class="bi bi-file-earmark-bar-graph"></i> View Report
                        </button>
                    </form>

                    <div class="card-body">
                        <div class="row align-items-center">
                            <h4 class="fw-bold py-3 mb-2">Daily Sales Report</h4>

                        </div>
                    </div>

                    <!-- Daily Sales Table -->
                    <div class="card shadow-sm rounded">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Date</th>
                                            <th>No. Orders</th>
                                            <th>Products Sold</th>
                                            <th>Total Sales (RM)</th>
                                            <th>Discounts Applied (RM)</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (Map<LocalDate, Object[]> dailyMap : dailySalesList) {
                                                for (Map.Entry<LocalDate, Object[]> entry : dailyMap.entrySet()) {
                                                    LocalDate date = entry.getKey();
                                                    Object[] metrics = entry.getValue();

                                                    int orderCount = (Integer) metrics[0];
                                                    int itemsSold = (Integer) metrics[1];
                                                    double revenue = (Double) metrics[2];
                                                    double discount = (Double) metrics[3];
                                        %>
                                        <tr>
                                            <td><%= date%></td>
                                            <td><%= orderCount%></td>
                                            <td><%= itemsSold%></td>
                                            <td><%= String.format("%.2f", revenue)%></td>
                                            <td><%= String.format("%.2f", discount)%></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/sales/details?date=<%=date%>" class="btn btn-sm btn-primary">
                                                    <i class="bi bi-eye"></i> View Details
                                                </a>
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

                    <div class="card-body">
                        <div class="row align-items-center">
                            <h4 class="fw-bold py-3 mb-2">Monthly Sales Report</h4>
                        </div>
                    </div>


                    <!-- Monthly Sales Table -->
                    <div class="card shadow-sm rounded">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Month</th>
                                            <th>No. Orders</th>
                                            <th>Products Sold</th>
                                            <th>Total Sales (RM)</th>
                                            <th>Discounts Applied (RM)</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (Map<String, Object[]> monthlyMap : monthlySalesList) {
                                                for (Map.Entry<String, Object[]> entry : monthlyMap.entrySet()) {
                                                    String month = entry.getKey(); // e.g., "JANUARY"
                                                    Object[] metrics = entry.getValue();

                                                    int orderCount = (Integer) metrics[0];
                                                    int itemsSold = (Integer) metrics[1];
                                                    double revenue = (Double) metrics[2];
                                                    double discount = (Double) metrics[3];
                                        %>
                                        <tr>
                                            <td><%= month.substring(0, 1).toUpperCase() + month.substring(1).toLowerCase()%></td>
                                            <td><%= orderCount%></td>
                                            <td><%= itemsSold%></td>
                                            <td><%= String.format("%.2f", revenue)%></td>
                                            <td><%= String.format("%.2f", discount)%></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/sales/details?month=<%=month%>" class="btn btn-sm btn-primary">
                                                    <i class="bi bi-eye"></i> View Details
                                                </a>
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

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Chart.js for charts -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="${pageContext.request.contextPath}/script/sidebarmenu.js"></script>
        <script src="${pageContext.request.contextPath}/script/script.js"></script>

    </body>
</html>






