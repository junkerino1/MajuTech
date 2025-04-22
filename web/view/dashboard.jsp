<%@ page contentType="text/html; charset=UTF-8" language="java" %>
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

            <!-- Include Sidebar -->
            <jsp:include page="sidebar.jsp" />

            <body>
                <!--  Body Wrapper -->
                <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
                     data-sidebar-position="fixed" data-header-position="fixed">
                    <!--  Main wrapper -->
                    <div class="body-wrapper">
                        <div class="container-fluid">
                            <!--  Row 1 -->
                            <div class="row">
                                <div class="col-lg-8 d-flex align-items-strech">
                                    <div class="card w-100">
                                        <div class="card-body">
                                            <div class="d-sm-flex d-block align-items-center justify-content-between mb-9">
                                                <div class="mb-3 mb-sm-0">
                                                    <h5 class="card-title fw-semibold">Sales Overview</h5>
                                                </div>
                                                <div>
                                                    <select class="form-select">
                                                        <option value="1">March 2023</option>
                                                        <option value="2">April 2023</option>
                                                        <option value="3">May 2023</option>
                                                        <option value="4">June 2023</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div id="chart">



                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <!-- Today's Sales -->
                                    <div class="card overflow-hidden">
                                        <div class="card-body p-4">
                                            <h5 class="card-title mb-9 fw-semibold">Today's Sales</h5>
                                            <div class="row align-items-center">
                                                <div class="col-8">
                                                    <h4 class="fw-semibold mb-3">$36,358</h4>
                                                    <div class="d-flex align-items-center mb-3">
                                                        <span class="me-1 rounded-circle bg-light-success round-20 d-flex align-items-center justify-content-center">
                                                            <i class="ti ti-arrow-up-left text-success"></i>
                                                        </span>
                                                        <p class="text-dark me-1 fs-3 mb-0">+9%</p>
                                                        <p class="fs-3 mb-0">yesterday</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Monthly Sales -->
                                    <div class="card">
                                        <div class="card-body">
                                            <div class="row align-items-start">
                                                <div class="col-8">
                                                    <h5 class="card-title mb-9 fw-semibold">Monthly Sales</h5>
                                                    <h4 class="fw-semibold mb-3">$6,820</h4>
                                                    <div class="d-flex align-items-center pb-1">
                                                        <p class="text-dark me-1 fs-3 mb-0">+9%</p>
                                                        <p class="fs-3 mb-0">last year</p>
                                                    </div>
                                                </div>
                                                <div class="col-4">
                                                    <div class="d-flex justify-content-end">
                                                        <div class="text-white bg-secondary rounded-circle p-6 d-flex align-items-center justify-content-center">
                                                            <i class="ti ti-currency-dollar fs-6"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="earning"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-8 d-flex align-items-stretch">
                                    <div class="card w-100">
                                        <div class="card-body p-4">
                                            <h5 class="card-title fw-semibold mb-4">Recent Transactions</h5>
                                            <div class="table-responsive">
                                                <table class="table text-nowrap mb-0 align-middle">
                                                    <thead class="text-dark fs-4">
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
                                                        <tr>
                                                            <td class="border-bottom-0">
                                                                <h6 class="fw-semibold mb-0">1</h6>
                                                            </td>
                                                            <td class="border-bottom-0">
                                                                <h6 class="fw-semibold mb-1">Sunil Joshi</h6>
                                                                <span class="fw-normal">Web Designer</span>
                                                            </td>
                                                            <td class="border-bottom-0">
                                                                <p class="mb-0 fw-normal">Elite Admin</p>
                                                            </td>
                                                            <td class="border-bottom-0">
                                                                <div class="d-flex align-items-center gap-2">
                                                                    <span class="badge bg-primary rounded-3 fw-semibold">Low</span>
                                                                </div>
                                                            </td>
                                                            <td class="border-bottom-0">
                                                                <h6 class="fw-semibold mb-0 fs-4">$3.9</h6>
                                                            </td>
                                                        </tr>
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

        </div>


        
        <script src="${pageContext.request.contextPath}/script/script.js"></script>
    </body>

</html>