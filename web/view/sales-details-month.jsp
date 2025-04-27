<%@page import="java.util.Date"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.Map"%>
<%@page import="model.Category"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Admin Panel - Monthly Sales Details</title>
        <link rel="icon" type="image" href="${pageContext.request.contextPath}/image/logo.png">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="${pageContext.request.contextPath}/script/sidebarmenu.js"></script>
        <script src="${pageContext.request.contextPath}/script/script.js"></script>
        <style>
            .sale-card {
                margin-bottom: 1rem;
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
                height: 350px;
            }
        </style>
    </head>

    <body>
        <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
             data-sidebar-position="fixed" data-header-position="fixed">

            <jsp:include page="sidebar.jsp" />
            <div class="body-wrapper">
                <jsp:include page="admin-header.jsp"/>

                <%
                    List<Map<String, Object>> productList = (List<Map<String, Object>>) request.getAttribute("productMap");

                    int monthlyOrderCount = (int) request.getAttribute("monthlyOrderCount");
                    int monthlyItemSold = (int) request.getAttribute("monthlyItemSold");
                    double monthlyRevenue = (double) request.getAttribute("monthlyRevenue");
                    double monthlyDiscount = (double) request.getAttribute("monthlyDiscount");
                    String monthParam = (String) request.getAttribute("monthParam"); // e.g. "April 2025"
                    String productListJson = (String) request.getAttribute("productListJson");
                %>

                <div class="container-fluid">
                    <div class="d-flex justify-content-between align-items-center py-3 mb-2">
                        <h4 class="fw-bold mb-0" id="pageTitle">Monthly Sales Details - <%= monthParam%></h4>
                        <a href="${pageContext.request.contextPath}/admin/sales" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i> Back to List
                        </a>
                    </div>

                    <!-- Monthly Sales Overview -->
                    <div class="row mb-4">
                        <div class="col-md-3 mb-3">
                            <div class="card stats-card bg-white h-100">
                                <div class="card-body">
                                    <div class="d-flex align-items-start justify-content-between">
                                        <div>
                                            <h5 class="card-title mb-1 text-muted">Total Revenue</h5>
                                            <h3 class="mb-0 fw-bold">RM <%= String.format("%.2f", monthlyRevenue)%></h3>
                                        </div>
                                        <div class="stats-icon bg-primary-subtle text-primary">
                                            <i class="bi bi-cash-stack"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card stats-card bg-white h-100">
                                <div class="card-body">
                                    <div class="d-flex align-items-start justify-content-between">
                                        <div>
                                            <h5 class="card-title mb-1 text-muted">Orders</h5>
                                            <h3 class="mb-0 fw-bold"><%= monthlyOrderCount%></h3>
                                        </div>
                                        <div class="stats-icon bg-success-subtle text-success">
                                            <i class="bi bi-cart-check"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card stats-card bg-white h-100">
                                <div class="card-body">
                                    <div class="d-flex align-items-start justify-content-between">
                                        <div>
                                            <h5 class="card-title mb-1 text-muted">Items Sold</h5>
                                            <h3 class="mb-0 fw-bold"><%= monthlyItemSold%></h3>
                                        </div>
                                        <div class="stats-icon bg-warning-subtle text-warning">
                                            <i class="bi bi-boxes"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card stats-card bg-white h-100">
                                <div class="card-body">
                                    <div class="d-flex align-items-start justify-content-between">
                                        <div>
                                            <h5 class="card-title mb-1 text-muted">Total Discount</h5>
                                            <h3 class="mb-0 fw-bold">RM <%= String.format("%.2f", monthlyDiscount)%></h3>
                                        </div>
                                        <div class="stats-icon bg-danger-subtle text-danger">
                                            <i class="bi bi-tag"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Products Sold Section -->
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center bg-white">
                            <h5 class="mb-0">Products Sold (Monthly)</h5>
                            <div>
                                <button type="button" class="btn btn-success" onclick="goToExportPage()">
                                    <i class="bi bi-file-earmark-excel"></i> Export to Excel
                                </button>
                                <button type="button" class="btn btn-danger ms-2" onclick="exportCurrentMonthPDF()">
                                    <i class="bi bi-file-earmark-pdf"></i> Export to PDF
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped" id="productsSoldTable">
                                    <thead>
                                        <tr>
                                            <th>Product ID</th>
                                            <th>Product Name</th>
                                            <th>Category</th>
                                            <th>Quantity Sold</th>
                                            <th>Unit Price (RM)</th>
                                            <th>Discount (RM)</th>
                                            <th>Total (RM)</th>
                                        </tr>
                                    </thead>
                                    <tbody id="productsSoldTableBody">
                                        <%
                                            for (int i = 0; i < productList.size(); i++) {
                                                Map<String, Object> product = productList.get(i);
                                        %>
                                        <tr>
                                            <td><%= product.get("id")%></td>
                                            <td><%= product.get("name")%></td>
                                            <td><%= product.get("category")%></td>
                                            <td><%= product.get("quantity")%></td>
                                            <td><%= String.format("%.2f", product.get("unitPrice"))%></td>
                                            <td><%= String.format("%.2f", product.get("discount"))%></td>
                                            <td><%= String.format("%.2f", product.get("total"))%></td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Sales by Day Chart (per month) -->
                    <div class="card">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">Sales by Day (Monthly)</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="monthlyChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Export libraries -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.25/jspdf.plugin.autotable.min.js"></script>

        <script>
                                    const config = {
                                        type: 'line',
                                        data: {
                                            labels: ${days}, // e.g. '2025-04-01', '2025-04-02', etc
                                            datasets: [
                                                {
                                                    label: 'Sales',
                                                    backgroundColor: 'rgba(78,115,223,0)',
                                                    borderColor: '#4e73df',
                                                    data: ${sales},
                                                    fill: true
                                                },
                                                {
                                                    label: 'Orders',
                                                    backgroundColor: 'rgba(255,0,0,0)',
                                                    borderColor: 'rgb(255,0,0)',
                                                    data: ${orders},
                                                    fill: true
                                                }
                                            ]
                                        },
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            scales: {
                                                y: {
                                                    beginAtZero: true,
                                                    position: 'left',
                                                    title: {display: true, text: 'Sales (RM)'}
                                                },
                                                y1: {
                                                    beginAtZero: true,
                                                    position: 'right',
                                                    grid: {drawOnChartArea: false},
                                                    title: {display: true, text: 'Number of Orders'}
                                                }
                                            }
                                        }
                                    };

                                    window.addEventListener('DOMContentLoaded', () => {
                                        const ctx = document.getElementById('monthlyChart').getContext('2d');
                                        new Chart(ctx, config);
                                    });

                                    const products = JSON.parse('<%= productListJson%>');
                                    const monthParam = '<%= monthParam%>';
                                    const monthlyRevenue = <%= monthlyRevenue%>;
                                    const monthlyOrderCount = <%= monthlyOrderCount%>;
                                    const monthlyItemSold = <%= monthlyItemSold%>;
                                    const monthlyDiscount = <%= monthlyDiscount%>;

                                    function goToExportPage() {
                                        localStorage.setItem("monthlyProducts", JSON.stringify(products));
                                        localStorage.setItem("monthParam", monthParam);
                                        localStorage.setItem("monthlyRevenue", monthlyRevenue);
                                        localStorage.setItem("monthlyOrderCount", monthlyOrderCount);
                                        localStorage.setItem("monthlyItemSold", monthlyItemSold);
                                        localStorage.setItem("monthlyDiscount", monthlyDiscount);

                                        window.open("../../view/export-month.html", "_blank");
                                    }

                                    function exportCurrentMonthPDF() {
                                        localStorage.setItem("monthlyProducts", JSON.stringify(products));
                                        localStorage.setItem("monthParam", monthParam);
                                        localStorage.setItem("monthlyRevenue", monthlyRevenue);
                                        localStorage.setItem("monthlyOrderCount", monthlyOrderCount);
                                        localStorage.setItem("monthlyItemSold", monthlyItemSold);
                                        localStorage.setItem("monthlyDiscount", monthlyDiscount);

                                        window.open("../../view/pdf-month.html", "_blank");
                                    }
        </script>
    </body>

</html>
