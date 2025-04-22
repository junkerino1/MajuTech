<%-- 
    Document   : admin-login
    Created on : Apr 21, 2025, 9:56:43 PM
    Author     : junky
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Admin Login</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
    </head>

    <body>
        <!--  Body Wrapper -->
        <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
             data-sidebar-position="fixed" data-header-position="fixed">


            <div
                class="position-relative overflow-hidden radial-gradient min-vh-100 d-flex align-items-center justify-content-center">
                <div class="d-flex align-items-center justify-content-center w-100">
                    <div class="row justify-content-center w-100">
                        <div class="col-md-8 col-lg-6 col-xxl-3">
                            <%
                                String message = (String) request.getAttribute("message");
                                if (message != null && !message.isEmpty()) {
                            %>
                            <div class="card text-white bg-danger mb-3" style="max-width: 100%;">
                                <div class="card-body">
                                    <p class="card-text"><%= message%></p>
                                </div>
                            </div>
                            <%
                                }
                            %>
                            <div class="card mb-0">

                                <div class="card-body">
                                    <div class="text-nowrap logo-img text-center d-block py-3 w-100">
                                        <img src="${pageContext.request.contextPath}/image/logo.png" width="100" alt="">
                                    </div>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/login">
                                        <div class="mb-3">
                                            <label for="exampleInputEmail1" class="form-label">Username</label>
                                            <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="username">
                                        </div>
                                        <div class="mb-4">
                                            <label for="exampleInputPassword1" class="form-label">Password</label>
                                            <input type="password" class="form-control" id="exampleInputPassword1" name="password">
                                        </div>

                                        <button type="submit" class="btn btn-primary w-100 py-8 fs-4 mb-4 rounded-2">Sign In</button>
                                        <div class="d-flex align-items-center justify-content-center">
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>

</html>