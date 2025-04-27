<%@page import="model.Admin"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" type="image" href="${pageContext.request.contextPath}/image/logo.png">
        <title>Admin Panel - List</title>
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
            
            /* Add action buttons styling */
            .action-buttons {
                display: flex;
                gap: 5px;
                flex-wrap: wrap;
            }
            
            /* Table responsiveness */
            .table-responsive {
                overflow-x: auto;
                width: 100%;
            }
            
            .table {
                width: 100%;
                min-width: 100%;
                table-layout: fixed;
                margin-bottom: 0;
            }
            
            .table th, .table td {
                padding: 0.75rem;
                word-wrap: break-word;
                overflow-wrap: break-word;
            }
            
            /* Column width control */
            .table th:nth-child(1), .table td:nth-child(1) {
                width: 15%;
            }
            .table th:nth-child(2), .table td:nth-child(2) {
                width: 35%;
            }
            .table th:nth-child(3), .table td:nth-child(3) {
                width: 25%;
            }
            .table th:nth-child(4), .table td:nth-child(4) {
                width: 25%;
            }
        </style>
        <script src="${pageContext.request.contextPath}/script/sidebarmenu.js"></script>
        <script src="${pageContext.request.contextPath}/script/script.js"></script>
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
                        String message = (String) session.getAttribute("message");
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
                        }
                        session.removeAttribute("message");
                    %>
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title">Admin List</h4>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Username</th>
                                            <th>Role</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            List<Admin> admins = (List<Admin>) request.getAttribute("adminList");
                                            if (admins != null) {
                                                for (Admin a : admins) {
                                        %>
                                        <tr>
                                            <td><%= a.getId()%></td>
                                            <td><%= a.getUsername()%></td>
                                            <td><%= a.getRole()%></td>

                                            <td>
                                                <div class="action-buttons">
                                                    <!-- Added Edit Button -->
                                                    <button class="btn btn-sm btn-primary" onclick="window.location.href = '${pageContext.request.contextPath}/admin/edit-staff?id=<%= a.getId()%>'">
                                                        <i class="bi bi-pen"></i>
                                                    </button>
                                                    
                                                    <form action="${pageContext.request.contextPath}/admin/delete-staff" method="post" style="display:inline;" onsubmit="return confirmDelete();">
                                                        <button class="btn btn-sm btn-danger" type="submit">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                        <input type="hidden" name="id" value="<%= a.getId()%>"/>
                                                    </form>
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

        <script>
            function confirmDelete() {
                return confirm("Are you sure you want to delete this staff?");
            }
        </script>
    </body>

</html>