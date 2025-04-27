<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" type="image" href="${pageContext.request.contextPath}/image/logo.png">
        <title>MajuTech</title>
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
                    <h5 class="card-title fw-semibold mb-4">Add Staff</h5>
                    <div class="card">
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/add-staff" method="post">
                                <div class="form-group-inline mb-3">
                                    <label for="staffName" class="form-label">Staff Name</label>
                                    <input type="text" class="form-control" id="staffName" name="name" placeholder="Enter staff name" required>
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label for="staffTitle" class="form-label">Role</label>
                                    <select class="form-control" id="staffTitle" name="role" required>
                                        <option value="" disabled selected>Select role</option>
                                        <option value="staff">Staff</option>
                                        <option value="manager">Manager</option>
                                    </select>
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label for="staffPassword" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="staffPassword" name="password" placeholder="Enter staff password" required>
                                </div>

                                <button type="submit" class="btn btn-primary">Submit</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>



            <script src="${pageContext.request.contextPath}/script/sidebarmenu.js"></script>
            <script src="${pageContext.request.contextPath}/script/script.js"></script>
    </body>

</html>