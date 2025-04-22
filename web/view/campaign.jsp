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

                <%
                    List<Campaign> campaigns = (List<Campaign>) request.getAttribute("campaigns");
                    Map<Integer, Integer> campaignItemCounts = (Map<Integer, Integer>) request.getAttribute("campaignItemCounts");
                %>


                <div class="container-fluid">
                    <div class="card">
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
                                            <th>Total Featured Products</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <%
                                            int index = 1;
                                            for (Campaign campaign : campaigns) {
                                                int id = campaign.getId();
                                                String name = campaign.getCampaignName();
                                                String start = campaign.getDateEnd().toString();
                                                String end = campaign.getDateStart().toString();
                                                double discount = campaign.getDiscountPercentage();
                                                int itemCount = campaignItemCounts.getOrDefault(id, 0);
                                        %>
                                        <tr>
                                            <td><%= index++%></td>
                                            <td><%= name%></td>
                                            <td><%= start%></td>
                                            <td><%= end%></td>
                                            <td><%= discount%>%</td>
                                            <td><%= itemCount%></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/view-campaign?id=<%= id%>" class="btn btn-sm btn-info text-white">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/edit-campaign?id=<%= id%>" class="btn btn-sm btn-primary">
                                                    <i class="bi bi-pen"></i>
                                                </a>
                                                <form action="${pageContext.request.contextPath}/delete-campaign" method="post" style="display:inline;">
                                                    <input type="hidden" name="id" value="<%= id%>">
                                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this campaign?');">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
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
            <script src="${pageContext.request.contextPath}/script/sidebarmenu.js"></script>
            <script src="${pageContext.request.contextPath}/script/script.js"></script>
    </body>
</html>
