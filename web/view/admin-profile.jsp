<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
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

            <!-- Main wrapper -->
            <div class="body-wrapper">
                <jsp:include page="admin-header.jsp" />
                <div class="container-fluid">
                    <%
                        String message = (String) session.getAttribute("message");
                        String error = (String) session.getAttribute("error");
                        if (message != null && !message.isEmpty()) {
                    %>
                    <div class="card text-white bg-success mb-3" id="message" style="max-width: 100%;">
                        <div class="card-body">
                            <p class="card-text"><%= message%></p>
                        </div>
                    </div>
                    <% } else if(error != null && !error.isEmpty()) {%>
                    <div class="card text-white bg-warning mb-3" id="message" style="max-width: 100%;">
                        <div class="card-body">
                            <p class="card-text"><%= error%></p>
                        </div>
                    </div>
                    <% }%>

                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const message = document.getElementById('message');

                            setTimeout(function () {
                                message.style.display = 'none';
                            }, 5000);
                        });
                    </script>
                    <div class="card">
                        <div class="card-body">
                            <div class="profile-header">
                                <div class="profile-info">
                                    <h2>Account Settings</h2>
                                    <p>Update your password here</p>
                                </div>
                            </div>

                            <div class="mt-4">
                                <h5 class="mb-4">Change Password</h5>
                                <form id="passwordChangeForm" action="${pageContext.request.contextPath}/admin/profile" method="post">
                                    <div class="mb-3">
                                        <label for="currentPassword" class="form-label">Current Password</label>
                                        <input type="password" class="form-control" name="currentPassword" id="currentPassword" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="newPassword" class="form-label">New Password</label>
                                        <input type="password" class="form-control" name="newPassword" id="newPassword" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                        <input type="password" class="form-control" id="confirmPassword" required>
                                    </div>

                                    <button type="submit" class="btn btn-primary">Update Password</button>
                                </form>
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
                        document.getElementById('passwordChangeForm').addEventListener('submit', function (event) {
                            const newPassword = document.getElementById('newPassword').value;
                            const confirmPassword = document.getElementById('confirmPassword').value;

                            if (newPassword !== confirmPassword) {
                                event.preventDefault();
                                alert('New Password and Confirm New Password do not match.');
                            }
                        });
    </script>
</body>

</html>