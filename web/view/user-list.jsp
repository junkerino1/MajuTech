<%@page import="model.User"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>User List</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />

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
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title">User List</h4>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Username</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>Gender</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            List<User> userList = (List<User>) request.getAttribute("userList");
                                            if (userList != null) {
                                                for (User user : userList) {
                                        %>
                                        <tr>
                                            <td><%= user.getId()%></td>
                                            <td><%= user.getUsername()%></td>
                                            <td><%= user.getEmail()%></td>
                                            <td><%= user.getPhone()%></td>
                                            <td><%= user.getGender()%></td>
                                            <td>
                                                <div style="display: inline-flex; gap: 10px;">
                                                    <form action="${pageContext.request.contextPath}/admin/delete-user" method="post" style="display:inline;" onsubmit="return confirmDelete();">
                                                        <button class="btn btn-sm btn-danger" type="submit">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                        <input type="hidden" name="id" value="<%= user.getId()%>"/>
                                                    </form>

                                                    <script>
                                                        function confirmDelete() {
                                                            return confirm("Are you sure you want to delete this user?");
                                                        }
                                                    </script>
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



    </body>
</html>
